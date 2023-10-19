# --- network/variables.tf ---

variable "vpc_cidr" {
  type = string
}

variable "public_cidrs" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  type = list(any)
}

variable "private_cidrs" {
  description = "Subnet CIDRs for private subnets (length must match configured availability_zones)"
  type = list(any)
}

variable "availability_zones" {
  description = "AZs in this region to use"
  default = ["us-east-1a", "us-east-1b"]
  type = list(any)
}