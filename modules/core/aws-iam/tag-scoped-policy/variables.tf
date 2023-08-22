variable "name" {
  description = "Policy Name"
  type = string
}

variable "original_policies" {
  description = "Read the permission list from the policies specified here."
  type = list(string)
}

variable "tags_scope" {
  description = "The policy created will grant permissions to resources with the specified tags only."
  type = map(string)
  nullable = false
}

variable "extra_tag_scoped_actions" {
  description = "AWS IAM actions that are not part of a policy but needs to be attached and can have its permissions tied to resourceTags. More info: https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html"
  type = list(string)
  default = []
}

variable "non_tag_scoped_actions" {
  description = "AWS IAM Actions that doesn´t supports resourceTag conditions. More info: https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html"
  type = list(string)
  default = []
}

variable "resource_scoped_actions" {
  description = "IAM Actions that can be applied to resources but not tags. Eg: S3. Required if `resource_scoped_arns` if set."
  type = list(string)
  default = []
}

variable "resource_scoped_arns" {
  description = "ARNs of the resources to be used with `resource_scoped_actions`. Required if `resource_scoped_actions` is set."
  type = list(string)
  default = []
}


variable "tags" {
  description = "Resource Tags."
  type        = map(string)
}
