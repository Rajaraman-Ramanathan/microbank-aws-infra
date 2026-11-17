
module "cluster_role" {
  source = "../../modules/eks/iam/cluster_role"

  cluster_name = var.cluster_name

  tags = local.common_tags
}

module "node_role" {
  source = "../../modules/eks/iam/node_role"

  cluster_name = var.cluster_name

  tags = local.common_tags
}
