# --- network/main.tf ---

# resource "random_integer" "random" {
#   min = 1
#   max = 1000
# }

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-jenkins"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name = "public_${count.index + 1}"
  }
}

# resource "aws_subnet" "test_private_subnet" {
#   count                   = length(var.private_cidrs)
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.private_cidrs[count.index]
#   map_public_ip_on_launch = false
#   availability_zone       = var.availability_zones[count.index]

#   tags = {
#     Name = "private_${count.index + 1}"
#   }
# }

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public"
  }
}

resource "aws_route" "default_public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_cidrs)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}


# #Elastic IP for NGW
# resource "aws_eip" "test_ngw" {
#   count = length(var.private_cidrs)
# }

# # Create NAT gateway
# resource "aws_nat_gateway" "test_ngw" {
#   count         = length(var.private_cidrs)
#   allocation_id = aws_eip.test_ngw.*.id[count.index]
#   subnet_id     = aws_subnet.public_subnet.*.id[count.index]
# }


# #Route Table for Private subnets   
# resource "aws_route_table" "test_private_rt" {
#   count  = length(var.private_cidrs)
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.test_ngw.*.id[count.index]
#   }
#   tags = {

#     Name = "private subnet route table"
#   }
# }
# # Create route table association betn prv a & NAT GW1
# resource "aws_route_table_association" "test_pri_sub_to_rt" {
#   count          = length(var.private_cidrs)
#   route_table_id = aws_route_table.test_private_rt.*.id[count.index]
#   subnet_id      = aws_subnet.test_private_subnet.*.id[count.index]
# }



resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow all inbound HTTP traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#ALB,ASG,LT design = always up scenario, single server
#ALB 
resource "aws_lb_target_group" "test_alb" {
  name        = "test-app-loadbalancer"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb" "test_alb" {
  depends_on         = [aws_internet_gateway.internet_gateway]
  #count              = length(var.public_cidrs)
  name               = "test-alb"
  subnets            = tolist(aws_subnet.public_subnet[*].id)
  #["${aws_subnet.public_subnet.*.id}"] 
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    "${aws_security_group.web_sg.id}",
  ]
  tags = {
    name = "test-AppLoadBalancer"
  }
}

resource "aws_lb_listener" "test_lb_listener" {
  load_balancer_arn = aws_lb.test_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_alb.arn
  }
}
