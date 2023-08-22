resource "aws_organizations_account" "account" {
  name  = var.name
  email = var.email

  close_on_deletion = var.close_on_deletion

  parent_id = var.parent_id
  tags = var.tags
}
