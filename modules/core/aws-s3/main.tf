locals {
  # From: https://github.com/aws/aws-cdk/blob/master/packages/%40aws-cdk/aws-s3/lib/perms.ts
  BUCKET_READ_ACTIONS = [
    "s3:GetObject*",
    "s3:GetBucket*",
    "s3:List*",
  ]
  BUCKET_WRITE_ACTIONS = [
    "s3:DeleteObject*",
    "s3:PutObject*",
    "s3:Abort*",
  ]
}

module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name
  acl    = var.bucket_acl

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  force_destroy = true

  tags = var.tags
}

data "aws_iam_policy_document" "allow-to-read" {
  statement {
    effect = "Allow"

    actions = local.BUCKET_READ_ACTIONS
    resources = [
      "${module.s3.s3_bucket_arn}/*"
    ]
  }

  statement {
    sid = "s3list"

    actions = [
      "s3:ListBucket",
    ]

    resources = [module.s3.s3_bucket_arn]
  }
}

data "aws_iam_policy_document" "allow-to-read-write" {
  statement {
    effect = "Allow"

    actions = concat(local.BUCKET_READ_ACTIONS, local.BUCKET_WRITE_ACTIONS)
    resources = [
      "${module.s3.s3_bucket_arn}/*"
    ]
  }

  statement {
    sid = "s3list"

    actions = [
      "s3:ListBucket",
    ]

    resources = [module.s3.s3_bucket_arn]
  }
}

resource "aws_iam_policy" "allow-to-read" {
  name   = "allow-to-read-${var.bucket_name}-s3-bucket"
  policy = data.aws_iam_policy_document.allow-to-read.json

  tags = var.tags
}

resource "aws_iam_policy" "allow-to-read-write" {
  name   = "allow-to-write-${var.bucket_name}-s3-bucket"
  policy = data.aws_iam_policy_document.allow-to-read-write.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "allow-to-read" {
  for_each   = toset(var.roles_allowed_to_read)
  role       = each.value
  policy_arn = aws_iam_policy.allow-to-read.arn
}

resource "aws_iam_role_policy_attachment" "allow-to-read-write" {
  for_each   = toset(var.roles_allowed_to_read_write)
  role       = each.value
  policy_arn = aws_iam_policy.allow-to-read-write.arn
}
