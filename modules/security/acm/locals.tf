locals {
  validation_domains = toset([
    for domain in concat(
      [var.domain_name],
      var.subject_alternative_names
    ) :
    trimprefix(domain, "*.")
  ])
}