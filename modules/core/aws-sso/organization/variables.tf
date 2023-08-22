variable "aws_service_access_principals" {
  type = list(string)
  default = []
}

variable "enabled_policy_types" {
  type = list(string)
  default = []
}

variable "feature_set" {
  type = string
  default = "ALL"
}
