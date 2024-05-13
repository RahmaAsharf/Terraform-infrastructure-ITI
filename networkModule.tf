module "network-lab2" {
  source   = "./network"
  vpc_cidr = var.vpc_cidr
  tag      = var.tag
  region   = var.region
  subnets  = var.subnets_details
}