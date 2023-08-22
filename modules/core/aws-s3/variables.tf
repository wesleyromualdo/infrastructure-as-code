variable "bucket_name" {
  type = string
}

variable "bucket_acl" {
  type    = string
  default = "private"
}

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "tags" {
  description = "Custom tags to add to resources"
  type        = map(string)
}

variable "roles_allowed_to_read_write" {
  description = "AWS Principals that can read and write the parameters under the parameters_prefix"
  type        = list(string)
  default     = []
}

variable "roles_allowed_to_read" {
  description = "AWS Principals that can read and write the parameters under the parameters_prefix"
  type        = list(string)
  default     = []
}
