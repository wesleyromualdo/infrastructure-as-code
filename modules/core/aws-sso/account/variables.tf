variable "name" {}

variable "email" {}

variable "parent_id" {}

variable "close_on_deletion" {
  type = bool
  default = true
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
}
