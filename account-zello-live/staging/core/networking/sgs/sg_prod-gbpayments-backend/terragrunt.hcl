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
  account_id  = local.account.locals.aws_account_id
  owner       = local.common.locals.owner
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

dependency "alb_sg" {
  config_path = "../../sgs/sg_main_alb"

  mock_outputs = {
    security_group_id = "sg-00000000"
  }
}

terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group?ref=v4.0.0"
}

inputs = {
  name        = "${local.environment}-gbpayments-backend"
  description = "Security group for ${local.environment}-gbpayments-backend"
  vpc_id      = dependency.vpc.outputs.vpc_id
  use_name_prefix = false

  ingress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 3000
      protocol                 = "tcp"
      description              = "HTTP"
      source_security_group_id = dependency.alb_sg.outputs.security_group_id
    },
  ]

  egress_rules         = ["all-all"]
  egress_cidr_blocks   = ["0.0.0.0/0"]

  tags = {
    Provider = "Terraform"
    Project = "gbpayments"
    Environment = local.environment
    Owner       = local.owner
  }
}
