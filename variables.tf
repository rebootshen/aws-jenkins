#This variable will be the name of your ec2 instance
variable "name" {
  type    = string
  default = "Jenkins"
}

#This variable contains your availability zone 
variable "az" {
  type    = string
  default = "us-east-1a"
}

#This variable you need to input your default VPC, it must be DEFAULT
variable "vpc_id" {
  type    = string
  default = "jenkins-cicd"
}

#This variable is the instance type you will be using
variable "type" {
  type    = string
  default = "t2.micro"
}

#This is your globally unique bucket name, meaning it has never been used
variable "bucket" {
  type    = string
  default = "jenkins-bucket-samshen"
}