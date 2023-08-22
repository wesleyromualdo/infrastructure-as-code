This module provides a way to create "tag scoped" policies from existing policies but with conditions/restrictions.

With this module, you can have, for example, a policy with "Administrator" privileges but only for the resources with specified tags.

More information on how to use tags to tie environment permissions can be viewed at: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_iam-tags.html

A complete example of how to use it can be seen below:
```hcl
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
```

In this example, a policy called "greenfield2-staging-admin-policy" will allow EC2FullPrivileges, but only for those resources that comply with the tag scope `{"Project":"GreenField2", "Environment": "staging"}`.

PS: Beware that not every action or policy on AWS can be used with conditions. More info: https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_tag_scoped_actions"></a> [extra\_tag\_scoped\_actions](#input\_extra\_tag\_scoped\_actions) | AWS IAM actions that are not part of a policy but needs to be attached and can have its permissions tied to resourceTags. More info: https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Policy Name | `string` | n/a | yes |
| <a name="input_non_tag_scoped_actions"></a> [non\_tag\_scoped\_actions](#input\_non\_tag\_scoped\_actions) | AWS IAM Actions that doesn´t supports resourceTag conditions. More info: https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html | `list(string)` | `[]` | no |
| <a name="input_original_policies"></a> [original\_policies](#input\_original\_policies) | Read the permission list from the policies specified here. | `list(string)` | n/a | yes |
| <a name="input_resource_scoped_actions"></a> [resource\_scoped\_actions](#input\_resource\_scoped\_actions) | IAM Actions that can be applied to resources but not tags. Eg: S3. Required if `resource_scoped_arns` if set. | `list(string)` | `[]` | no |
| <a name="input_resource_scoped_arns"></a> [resource\_scoped\_arns](#input\_resource\_scoped\_arns) | ARNs of the resources to be used with `resource_scoped_actions`. Required if `resource_scoped_actions` is set. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource Tags. | `map(string)` | n/a | yes |
| <a name="input_tags_scope"></a> [tags\_scope](#input\_tags\_scope) | The policy created will grant permissions to resources with the specified tags only. | `map(string)` | n/a | yes |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | n/a |
| <a name="output_policy_name"></a> [policy\_name](#output\_policy\_name) | n/a |

