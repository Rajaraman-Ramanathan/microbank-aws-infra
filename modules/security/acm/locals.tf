locals {
  validation_records = {
    for record_name, records in {
      for dvo in aws_acm_certificate.this.domain_validation_options :
      dvo.resource_record_name => {
        name  = dvo.resource_record_name
        value = dvo.resource_record_value
        type  = dvo.resource_record_type
      }...
    } :
    record_name => records[0]
  }
}
