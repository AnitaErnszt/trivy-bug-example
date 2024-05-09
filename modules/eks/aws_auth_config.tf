locals {
  aws_auth_system_roles = [
    {
      rolearn  = module.eks.eks_managed_node_groups["worker"].iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    }
  ]
}

module "aws_auth_configmap" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.8.5"

  manage_aws_auth_configmap = true

  aws_auth_roles = flatten([
    [local.aws_auth_system_roles],
    [var.aws_auth_roles]
  ])
}
