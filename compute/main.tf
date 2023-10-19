# --- compute/main.tf ---

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    #"ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("ssh_keys/my_aws.pub")
}

resource "aws_launch_template" "web" {
  name_prefix            = "web"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.web_instance_type
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [var.web_sg]
  user_data              = filebase64("script/install_apache.sh")

  # provisioner "file" {
  #   source      = "static/index.html"
  #   destination = "/tmp/index.html"
  # }

  # provisioner "file" {
  #   source      = "static/web.tar"
  #   destination = "/tmp/web.tar"
  # }

  # provisioner "file" {
  #   source      = "script/install_web.sh"
  #   destination = "/home/ubuntu/install_web.sh"
  # }
  
  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /home/ubuntu/install_web.sh",
  #     "sudo /home/ubuntu/install_web.sh"
  #   ]
  # }

  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   private_key = file("ssh_keys/my_aws")
  #   host        = self.public_ip
  # }

  tags = {
    Name = "web"
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "web"
  vpc_zone_identifier = tolist(var.public_subnet)
  min_size            = 2
  max_size            = 2
  desired_capacity    = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  target_group_arns   = [var.test_tg]
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

