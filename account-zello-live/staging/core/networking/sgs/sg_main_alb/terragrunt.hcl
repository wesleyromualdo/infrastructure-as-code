include {
  path = "${find_in_parent_folders()}"
}

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


terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group?ref=v4.0.0"
}

dependency "vpc" {
  config_path = "../../vpc"

  mock_outputs = {
    vpc_id = "vpc-00000000"
    private_subnets = [
      "subnet-00000000",
      "subnet-00000001",
      "subnet-00000002",
    ]
    database_route_table_ids = [""]
    private_route_table_ids = [""]
    public_route_table_ids = [""]
  }
}


inputs = {
  name        = "${local.environment}-main-alb-http-https"
  description = "Security group for the DMZ zone"
  vpc_id      = dependency.vpc.outputs.vpc_id
  use_name_prefix = false

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp","http-80-tcp"]
  ingress_ipv6_cidr_blocks = ["::/0"]

  egress_rules         = ["all-all"]
  egress_cidr_blocks   = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]

  tags = {
    Provider = "Terraform"
    Project = local.project
    Environment = local.environment
    Owner       = local.owner
    Name    = "${local.environment}-public-http-https"
  }
}
