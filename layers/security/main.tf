module "kms" {
  source = "../../modules/security/kms"

  name        = "microbank-kms"
  description = "Microbank platform KMS key"
  admin_principals = [
    "arn:aws:iam::123456789012:role/platform-admin"
  ]
  usage_principals = [
    module.node_role.node_role_arn
  ]

  tags = local.common_tags
}

module "db_secret" {
  source = "../../modules/security/secrets_manager"

  name        = "microbank-db-credentials"
  description = "Database credentials"
  kms_key_arn = module.kms.key_arn
  secret_map = {
    username = "admin"
    password = "super-secure-password"
    host     = "postgres.internal"
    port     = "5432"
  }
  enable_resource_policy = true
  allowed_principals = [
    module.node_role.node_role_arn
  ]

  tags = local.common_tags
}

module "api_secret" {
  source = "../../modules/security/secrets_manager"

  name        = "payment-api-key"
  description = "Payment provider API key"
  kms_key_arn = module.kms.key_arn
  secret_string = "super-secret-api-key"

  tags = local.common_tags
}

module "acm" {
  source = "../../modules/security/acm"

  domain_name = "*.microbank.com"
  hosted_zone_id = module.route53.zone_id
  subject_alternative_names = [
    "microbank.com"
  ]

  tags = local.common_tags
}

module "waf" {
  source = "../../modules/security/waf"

  name = "microbank-waf"
  alb_arn = module.alb.alb_arn
  rate_limit = 2000

  tags = local.common_tags
}