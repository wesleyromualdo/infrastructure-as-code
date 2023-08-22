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

terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-rds-aurora?ref=v7.6.2"
}

dependency "vpc" {
  config_path = "../../networking/vpc"

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

dependency "sg" {
  config_path = "../../networking/sgs/sg_prod-gbpayments-backend"

  mock_outputs = {
    security_group_id = "vpc-00000000"
  }
}

dependency "kms" {
  config_path = "../../kms/gbpayments"

  mock_outputs = {
    kms-key-id = "xxxxxxxxxxxx"
  }
}

inputs = {
  name           = "${local.environment}-gbpayments"
  engine         = "aurora-postgresql"
  engine_mode    = "provisioned"
  engine_version = "14.5"

  master_username = "flatiron"

  vpc_id                  = dependency.vpc.outputs.vpc_id
  subnets                 = dependency.vpc.outputs.database_subnets
  create_security_group   = true
  db_subnet_group_name    = "db_${local.environment}_gbpayments"
  allowed_security_groups = [dependency.sg.outputs.security_group_id]
  publicly_accessible     = true

  backup_retention_period = 1

  storage_encrypted = true
  kms_key_id        = dependency.kms.outputs.key_arn

  apply_immediately   = true
  skip_final_snapshot = true

  multi_az = false

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 1
  }

  instance_class = "db.serverless"
  instances      = {
    one = {}
  }

  tags = {
    Provider    = "Terraform"
    Project     = "dbpayments"
    Environment = local.environment
    Owner       = local.owner
  }
}
