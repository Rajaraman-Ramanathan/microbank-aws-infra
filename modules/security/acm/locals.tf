locals {
  validation_domains = distinct([
    for domain in concat(
      [var.domain_name],
      var.subject_alternative_names
    ) :
    replace(domain, "*.", "")
  ])
}