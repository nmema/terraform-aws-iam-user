data "aws_caller_identity" "current" {}

resource "aws_iam_user" "user" {
  name = var.iam_user_name
}

resource "aws_iam_role" "s3_support_role" {
  name = "S3SupportRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.user.arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_write_policy" {
  name        = "S3WritePolicy"
  description = "Policy to allow write access to S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObject"
        ]
        Resource = [
          aws_s3_bucket.bucket.arn,
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_write_policy" {
  role       = aws_iam_role.s3_support_role.name
  policy_arn = aws_iam_policy.s3_write_policy.arn
}

resource "aws_iam_user_policy" "role_switching_policy" {
  user = aws_iam_user.user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.s3_support_role.arn
      }
    ]
  })
}

resource "aws_iam_access_key" "user_key" {
  user = aws_iam_user.user.name
}
