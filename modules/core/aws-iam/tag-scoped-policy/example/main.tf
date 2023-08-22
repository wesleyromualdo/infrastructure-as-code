module "tag-policy" {
  source = "../"

  name              = "greenfield2-staging-admin-policy"
  original_policies = ["AmazonSSMReadOnlyAccess", "AmazonEC2FullAccess", "AdministratorAccess"]
  extra_tag_scoped_actions = []
  non_tag_scoped_actions = ["ecs:RegisterTaskDefinition", "ecs:DescribeTaskDefinition", "ecr:GetAuthorizationToken"]
  resource_scoped_actions = ["iam:PassRole"]
  resource_scoped_arns = ["arn:aws:iam::00000000000000:role/service-role/snowflake-role"]
  tags_scope        = {"Project":"GreenField2", "Environment": "staging"}
  tags = {
    Project = "TerraformModules"
  }
}
