# --- comput/variables.tf ---

variable "web_sg" {}
variable "public_subnet" {}
variable "test_tg" {}


variable "web_instance_type" {
  type    = string
  default = "t2.micro"
}

