## Requirements

No requirements.

## Providers

| Name                                              | Version |
| ------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a     |

## Modules

| Name                                       | Source                              | Version |
| ------------------------------------------ | ----------------------------------- | ------- |
| <a name="module_s3"></a> [s3](#module\_s3) | terraform-aws-modules/s3-bucket/aws | ~> 2.0  |

## Resources

| Name                                                                                                                                                         | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_iam_policy.allow-to-read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                       | resource    |
| [aws_iam_policy.allow-to-read-write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                 | resource    |
| [aws_iam_role_policy_attachment.allow-to-read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)       | resource    |
| [aws_iam_role_policy_attachment.allow-to-read-write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_policy_document.allow-to-read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                  | data source |
| [aws_iam_policy_document.allow-to-read-write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)            | data source |

## Inputs

| Name                                                                                                                        | Description                                                                        | Type           | Default     | Required |
| --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- | -------------- | ----------- |:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name)                                                       | n/a                                                                                | `string`       | n/a         | yes      |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                              | Custom tags to add to resources                                                    | `map(string)`  | n/a         | yes      |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls)                                   | n/a                                                                                | `bool`         | `true`      | no       |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy)                             | n/a                                                                                | `bool`         | `true`      | no       |
| <a name="input_bucket_acl"></a> [bucket\_acl](#input\_bucket\_acl)                                                          | n/a                                                                                | `string`       | `"private"` | no       |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls)                                | n/a                                                                                | `bool`         | `true`      | no       |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets)                 | n/a                                                                                | `bool`         | `true`      | no       |
| <a name="input_roles_allowed_to_read"></a> [roles\_allowed\_to\_read](#input\_roles\_allowed\_to\_read)                     | AWS Principals that can read and write the parameters under the parameters\_prefix | `list(string)` | `[]`        | no       |
| <a name="input_roles_allowed_to_read_write"></a> [roles\_allowed\_to\_read\_write](#input\_roles\_allowed\_to\_read\_write) | AWS Principals that can read and write the parameters under the parameters\_prefix | `list(string)` | `[]`        | no       |

## Outputs

| Name                                                                                                                                                          | Description |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn)                                                                               | n/a         |
| <a name="output_s3_bucket_bucket_domain_name"></a> [s3\_bucket\_bucket\_domain\_name](#output\_s3\_bucket\_bucket\_domain\_name)                              | n/a         |
| <a name="output_s3_bucket_bucket_regional_domain_name"></a> [s3\_bucket\_bucket\_regional\_domain\_name](#output\_s3\_bucket\_bucket\_regional\_domain\_name) | n/a         |
| <a name="output_s3_bucket_hosted_zone_id"></a> [s3\_bucket\_hosted\_zone\_id](#output\_s3\_bucket\_hosted\_zone\_id)                                          | n/a         |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id)                                                                                  | n/a         |
| <a name="output_s3_bucket_region"></a> [s3\_bucket\_region](#output\_s3\_bucket\_region)                                                                      | n/a         |
| <a name="output_s3_bucket_website_domain"></a> [s3\_bucket\_website\_domain](#output\_s3\_bucket\_website\_domain)                                            | n/a         |
| <a name="output_s3_bucket_website_endpoint"></a> [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint)                                      | n/a         |
