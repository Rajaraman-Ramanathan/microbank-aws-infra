output "certificate_arn" {
  description = "Validated ACM certificate ARN"
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "certificate_domain" {
  description = "Primary ACM certificate domain"
  value       = aws_acm_certificate.this.domain_name
}