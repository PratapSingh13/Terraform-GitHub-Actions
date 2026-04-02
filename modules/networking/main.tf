locals {
  environment = terraform.workspace != "default" ? terraform.workspace : "dev"
}

module "vpc" {
  source = "./vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  project     = var.project
}

module "igw" {
  source = "./igw"

  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  project     = var.project

  depends_on = [module.vpc]
}

module "public_subnet" {
  source = "./subnet/public-subnet"

  vpc_id              = module.vpc.vpc_id
  public_subnets_cidr = var.public_subnets_cidr
  availability_zones  = var.availability_zones
  environment         = var.environment
  project             = var.project

  depends_on = [module.vpc]
}

module "public_route_table" {
  source = "./route-table/public-route-table"

  vpc_id      = module.vpc.vpc_id
  igw_id      = module.igw.igw_id
  environment = var.environment
  project     = var.project
  # Pass the public subnets CIDR blocks to the route table association
  public_subnets_cidr = module.public_subnet.public_subnet_ids

  depends_on = [module.public_subnet]
}

module "security_group" {
  source = "./security-group"

  create_security_group          = var.create_security_group
  environment                    = var.environment
  vpc_id                         = module.vpc.vpc_id
  security_group_name            = "${var.environment}-${var.project}-default-sg"
  security_group_use_name_prefix = var.security_group_use_name_prefix
  security_group_description     = "This security group belongs to general applications in the ${var.environment} environment for the ${var.project} project"
  security_group_tags            = var.security_group_tags
  security_group_ingress_rules   = var.security_group_ingress_rules
  security_group_egress_rules    = var.security_group_egress_rules

  tags = merge(var.tags, { terraform-aws-modules = "sg" })

  depends_on = [module.vpc]
}
