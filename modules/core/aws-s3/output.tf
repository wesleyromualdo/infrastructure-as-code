output "s3_bucket_arn" {
  value = module.s3.s3_bucket_arn
}

output "s3_bucket_bucket_domain_name" {
  value = module.s3.s3_bucket_bucket_domain_name
}

output "s3_bucket_bucket_regional_domain_name" {
  value = module.s3.s3_bucket_bucket_regional_domain_name
}

output "s3_bucket_hosted_zone_id" {
  value = module.s3.s3_bucket_hosted_zone_id
}

output "s3_bucket_id" {
  value = module.s3.s3_bucket_id
}

output "s3_bucket_region" {
  value = module.s3.s3_bucket_region
}

output "s3_bucket_website_domain" {
  value = module.s3.s3_bucket_website_domain
}

output "s3_bucket_website_endpoint" {
  value = module.s3.s3_bucket_website_endpoint
}

output "read_policy_arn" {
  value = aws_iam_policy.allow-to-read.arn
}

output "read_write_policy_arn" {
  value = aws_iam_policy.allow-to-read-write.arn
}
