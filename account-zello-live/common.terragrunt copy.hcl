# Set common variables for the project. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.

locals {
  environment = "production"
  prefix      = "iac"
  bu          = "rpa"
  owner       = "DevOpsTeam"
}
