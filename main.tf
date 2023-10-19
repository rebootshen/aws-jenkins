# --- root/main.tf ---

module "network" {
  source             = "./network"
  vpc_cidr           = "10.0.0.0/16"
  public_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs      = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}

module "compute" {
  source        = "./compute"
  web_sg        = module.network.web_sg
  public_subnet = module.network.public_subnet
  test_tg        = module.network.test_tg
}