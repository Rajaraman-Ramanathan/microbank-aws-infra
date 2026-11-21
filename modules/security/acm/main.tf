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
      Name = "microbankapp.com-wildcard-certificate"
    }
  )
}



resource "aws_route53_record" "validation" {
  for_each = toset(local.validation_domains)

  zone_id = var.hosted_zone_id

  name = [
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.resource_record_name
    if trimprefix(dvo.domain_name, "*.") == each.key
  ][0]

  type = [
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.resource_record_type
    if trimprefix(dvo.domain_name, "*.") == each.key
  ][0]

  records = [
    [
      for dvo in aws_acm_certificate.this.domain_validation_options :
      dvo.resource_record_value
      if trimprefix(dvo.domain_name, "*.") == each.key
    ][0]
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