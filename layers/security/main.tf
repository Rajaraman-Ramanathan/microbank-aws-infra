
# --------------------------------------------------
# AWS account information
# --------------------------------------------------

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# --------------------------------------------------
# KMS
# --------------------------------------------------

module "kms" {
  source = "../../modules/security/kms"

  name        = "microbank-kms"
  description = "Microbank platform KMS key"

  admin_principals = [
    "arn:aws:iam::123456789012:role/platform-admin"
  ]

  # ESO receives KMS permissions through its dedicated
  # IAM policy. No direct node-role access is required.
  usage_principals = []

  eks_provisioning_principals = [
    "arn:aws:iam::123456789012:role/terraform-deployment-role"
  ]

  tags = local.common_tags
}

# --------------------------------------------------
# Database credentials in AWS Secrets Manager
# --------------------------------------------------

module "db_secret" {
  source = "../../modules/security/secret_manager"

  name        = "microbank-db-credentials"
  description = "Microbank RDS PostgreSQL credentials"

  kms_key_arn = module.kms.key_arn

  secret_map = {
    username = "admin"
    password = "REPLACE_WITH_SECURELY_INJECTED_VALUE"
    host     = "postgres.internal"
    port     = "5432"
  }

  # ESO uses identity-based IAM permissions.
  enable_resource_policy = false
  allowed_principals     = []

  tags = local.common_tags
}

# --------------------------------------------------
# Payment API credentials in AWS Secrets Manager
# --------------------------------------------------

module "api_secret" {
  source = "../../modules/security/secret_manager"

  name        = "microbank-payment-api-key"
  description = "Microbank payment provider API key"

  kms_key_arn = module.kms.key_arn

  secret_string = "REPLACE_WITH_SECURELY_INJECTED_VALUE"

  enable_resource_policy = false
  allowed_principals     = []

  tags = local.common_tags
}

# --------------------------------------------------
# External Secrets Operator IAM policy
# --------------------------------------------------

data "aws_iam_policy_document" "external_secrets" {

  statement {
    sid    = "AllowReadMicrobankSecrets"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:microbank-*"
    ]
  }

  statement {
    sid    = "AllowDecryptMicrobankSecrets"
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = [
      module.kms.key_arn
    ]
  }
}

resource "aws_iam_policy" "external_secrets" {
  name        = "microbank-external-secrets-policy"
  description = "Allows External Secrets Operator to retrieve Microbank secrets"

  policy = data.aws_iam_policy_document.external_secrets.json

  tags = local.common_tags
}

# --------------------------------------------------
# ACM public certificate
# --------------------------------------------------

module "acm" {
  source = "../../modules/security/acm"

  domain_name = "*.microbank.com"

  hosted_zone_id = data.terraform_remote_state.dns.outputs.public_zone_id

  subject_alternative_names = [
    "microbank.com"
  ]

  tags = local.common_tags
}
