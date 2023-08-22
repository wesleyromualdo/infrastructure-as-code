include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc//modules/vpc-endpoints?ref=v3.0.0"
}

dependency "vpc" {
  config_path = "../vpc"

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
  config_path = "../sgs/sg_vpc_endpoints"
}


inputs = {

  vpc_id             = dependency.vpc.outputs.vpc_id
  security_group_ids = [dependency.vpc.outputs.default_security_group_id]

  endpoints = {
    s3 = {
      service = "s3"
      tags    = { Name = "s3-vpc-endpoint" }
      subnet_ids          = dependency.vpc.outputs.private_subnets
      security_group_ids  = [dependency.sg.outputs.security_group_id]
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      security_group_ids  = [dependency.sg.outputs.security_group_id]
      tags            = { Name = "ecr-api-vpc-endpoint" }
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      security_group_ids  = [dependency.sg.outputs.security_group_id]
      tags            = { Name = "ecr-dkr-vpc-endpoint" }
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      security_group_ids  = [dependency.sg.outputs.security_group_id]
      tags            = { Name = "ssmmessages-vpc-endpoint" }
    }
  }
}
