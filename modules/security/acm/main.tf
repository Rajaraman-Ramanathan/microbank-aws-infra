resource "aws_acm_certificate" "this" {
  domain_name = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = var.subject_alternative_names

  options {
    certificate_transparency_logging_preference = (
      var.certificate_transparency_logging_preference
      ? "ENABLED"
      : "DISABLED"
    )
  }
  
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = var.domain_name
    }
  )
}


resource "aws_route53_record" "validation" {
  for_each = toset(local.validation_domains)

  zone_id = var.hosted_zone_id

  name = one([
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.resource_record_name
    if replace(dvo.domain_name, "*.", "") == each.key
  ])

  type = one([
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.resource_record_type
    if replace(dvo.domain_name, "*.", "") == each.key
  ])

  records = [
    one([
      for dvo in aws_acm_certificate.this.domain_validation_options :
      dvo.resource_record_value
      if replace(dvo.domain_name, "*.", "") == each.key
    ])
  ]

  ttl             = 60
  allow_overwrite = true
}


resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn

  validation_record_fqdns = [
    for record in aws_route53_record.validation :
    record.fqdn
  ]

  timeouts {
    create = "30m"
  }
}