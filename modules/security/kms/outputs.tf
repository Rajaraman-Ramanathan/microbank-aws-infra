output "key_arn" {
  value = aws_kms_key.this.arn
}

output "key_id" {
  value = aws_kms_key.this.key_id
}

output "alias" {
  value = aws_kms_alias.this.name
}

output "certificate_arn" {
  description = "Validated ACM certificate ARN"
  value       = aws_acm_certificate_validation.this.certificate_arn
}