module "s3" {
  source = "../../"

  bucket_name = "f491b9f5-86f4-48f0-bb67-bc9ac1ee0e65"

  tags = {
    Owner = "DevOpsTeam"
  }
}
