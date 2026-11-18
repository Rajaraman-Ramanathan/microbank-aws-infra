output "kms_key_arn" {
  description = "KMS key ARN used by Microbank"
  value       = module.kms.key_arn
}

output "kms_key_id" {
  description = "KMS key ID used by Microbank"
  value       = module.kms.key_id
}

output "external_secrets_policy_arn" {
  description = "IAM policy ARN for External Secrets Operator"
  value       = aws_iam_policy.external_secrets.arn
}

output "acm_certificate_arn" {
  description = "Validated ACM certificate ARN"
  value       = module.acm.certificate_arn
}