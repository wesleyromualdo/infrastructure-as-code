locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.terragrunt.hcl"))
  common           = read_terragrunt_config(find_in_parent_folders("common.terragrunt.hcl"))
  account          = read_terragrunt_config(find_in_parent_folders("account.terragrunt.hcl"))

  # Extract out common variables for reuse
  environment = local.common.locals.environment
  aws_region  = local.region_vars.locals.aws_region
  project     = "shared_resources"
  account_id  = local.account.locals.aws_account_id
  owner       = local.common.locals.owner
}

include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v4.0.2"
}

inputs = {

  name = "vpc-main-${local.environment}"

  cidr = "10.168.0.0/16"

  azs = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
  
  public_subnets = ["10.168.48.0/20", "10.168.64.0/20", "10.168.80.0/20"]
  private_subnets = ["10.168.96.0/20", "10.168.112.0/20", "10.168.128.0/20"]
  database_subnets = ["10.168.144.0/20", "10.168.160.0/20", "10.168.176.0/20"]
  elasticache_subnets = ["10.168.192.0/20", "10.168.208.0/20", "10.168.224.0/20"]

  create_database_subnet_group = false
  create_database_subnet_route_table = true
  create_database_internet_gateway_route = true

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support = true

  manage_default_security_group = true
  default_security_group_ingress = []
  default_security_group_egress = []

  public_subnet_tags = {
    "Owner" = "DevOps"
  }

  private_subnet_tags = {
    "Owner" = "DevOps"
  }

  tags = {
    Provider = "Terraform"
    Project = local.project
    Environment = local.environment
    Owner       = local.owner
  }

}
