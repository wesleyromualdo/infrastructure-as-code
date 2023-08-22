# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.terragrunt.hcl"))
  account = read_terragrunt_config(find_in_parent_folders("account.terragrunt.hcl"))
  region = read_terragrunt_config(find_in_parent_folders("region.terragrunt.hcl"))
  environment = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
  role_configuration = read_terragrunt_config("role_configuration.hcl", {locals={assume_role_arn=""}})
}

remote_state {
  backend = "s3"
  config = {
    encrypt = true
    region = local.region.locals.aws_region
    bucket = "terraform-state-${local.account.locals.aws_account_id}"
    key = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "terraform-locks-${local.account.locals.aws_account_id}"
    s3_bucket_tags = {
      name = "Terraform State File"
      Owner = local.common.locals.owner
    }
    dynamodb_table_tags = {
      name = "Terraform Lock Table"
      Owner = local.common.locals.owner
    }
  }

  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = templatefile("provider.tpl", {
    region = local.region.locals.aws_region,
    account_id = local.account.locals.aws_account_id,
    assume_role_arn = local.role_configuration.locals.assume_role_arn
  } )
}
