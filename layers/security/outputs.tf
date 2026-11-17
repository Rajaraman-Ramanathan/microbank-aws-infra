output "kms_key_arn" {
  description = "KMS key ARN used by Microbank"
  value       = module.kms.key_arn
}

output "kms_key_id" {
  description = "KMS key ID used by Microbank"
  value       = module.kms.key_id
}