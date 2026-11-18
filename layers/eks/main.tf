
module "eks_cluster" {
  source = "../../modules/eks/cluster"

  cluster_name              = var.cluster_name
  cluster_version           = var.cluster_version
  private_subnet_ids        = data.terraform_remote_state.network.outputs.private_subnet_ids
  cluster_role_arn          = data.terraform_remote_state.iam.outputs.cluster_role_arn
  cluster_security_group_id = data.terraform_remote_state.network.outputs.eks_cluster_sg_id
  kms_key_arn               = data.terraform_remote_state.security.outputs.kms_key_arn

  tags = local.common_tags
}

module "node_groups" {
  source = "../../modules/eks/node_groups"

  cluster_name             = module.eks_cluster.cluster_name
  node_role_arn            = data.terraform_remote_state.iam.outputs.node_role_arn
  private_subnet_ids       = data.terraform_remote_state.network.outputs.private_subnet_ids
  launch_template_id       = module.launch_template.launch_template_id
  launch_template_version  = module.launch_template.latest_version
  node_groups              = local.node_groups

  tags = local.common_tags
}

module "launch_template" {
  source = "../../modules/eks/launch_template"

  cluster_name           = var.cluster_name
  node_security_group_id = data.terraform_remote_state.network.outputs.eks_node_sg_id

  tags = local.common_tags
}

module "oidc" {
  source = "../../modules/eks/oidc"

  cluster_name = module.eks_cluster.cluster_name
  tags         = local.common_tags

  depends_on = [module.eks_cluster]
}

module "irsa_external_dns" {
  source = "../../modules/eks/iam/irsa"

  cluster_name      = var.cluster_name
  namespace         = "kube-system"
  service_account   = "external-dns-sa"
  oidc_provider_arn = module.oidc.arn
  oidc_provider_url = module.oidc.url

  policy_arns = [
    data.terraform_remote_state.security.outputs.external_dns_policy_arn
  ]

  tags = local.common_tags

  depends_on = [module.oidc]
}

module "irsa_alb" {
  source = "../../modules/eks/iam/irsa"

  cluster_name      = var.cluster_name
  namespace         = "kube-system"
  service_account   = "aws-load-balancer-controller-sa"
  oidc_provider_arn = module.oidc.arn
  oidc_provider_url = module.oidc.url

  policy_arns = [
    data.terraform_remote_state.security.outputs.alb_controller_policy_arn
  ]

  tags = local.common_tags

  depends_on = [module.oidc]
}

module "irsa_ebs_csi" {
  source = "../../modules/eks/iam/irsa"

  cluster_name      = var.cluster_name
  namespace         = "kube-system"
  service_account   = "ebs-csi-controller-sa"
  oidc_provider_arn = module.oidc.arn
  oidc_provider_url = module.oidc.url

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]

  tags = local.common_tags

  depends_on = [module.oidc]
}

module "irsa_external_secrets" {
  source = "../../modules/eks/iam/irsa"

  cluster_name      = var.cluster_name
  namespace         = "external-secrets"
  service_account   = "external-secrets-sa"
  oidc_provider_arn = module.oidc.arn
  oidc_provider_url = module.oidc.url

  policy_arns = [
    data.terraform_remote_state.security.outputs.external_secrets_policy_arn
  ]

  tags = local.common_tags

  depends_on = [
    module.oidc
  ]
}

module "addons" {
  source = "../../modules/eks/addons"

  cluster_name = module.eks_cluster.cluster_name

  tags = local.common_tags

  depends_on = [
    module.node_groups
  ]
}
