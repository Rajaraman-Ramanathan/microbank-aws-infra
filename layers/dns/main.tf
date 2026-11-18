module "public_zone" {
  source = "../../modules/dns/route53"

  domain_name  = "microbank.com"
  private_zone = false

  tags = local.common_tags
}

module "private_zone" {
  source = "../../modules/dns/route53"

  domain_name  = "internal.microbank.local"
  private_zone = true
  vpc_id       = data.terraform_remote_state.network.outputs.vpc_id

  tags = local.common_tags
}