output "access_key_id" {
  description = "AWS Access Key ID for AWS CLI"
  value       = aws_iam_access_key.user_key.id
  sensitive   = true
}

output "secret_access_key" {
  description = "AWS Secret Access Key for AWS CLI"
  value       = aws_iam_access_key.user_key.secret
  sensitive   = true
}

output "role_arn" {
  description = "IAM Role ARN"
  value       = aws_iam_role.s3_support_role.arn
}
