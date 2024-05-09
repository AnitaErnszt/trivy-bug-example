################################################################################
# EKS Module
################################################################################
# trivy:ignore:AVD-AWS-0040
# trivy:ignore:AVD-AWS-0041
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8.5"

  cluster_name                   = local.cluster_name
  cluster_endpoint_public_access = true
  cluster_enabled_log_types      = var.enabled_log_types
  enable_irsa                    = true

  cluster_addons = {
    coredns                = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  # External encryption key
  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = module.kms.key_arn
  }

  # Attach IAM policy to reach ECR from node group
  iam_role_additional_policies = {
    eks_ecr_access = aws_iam_policy.eks_ecr_access.arn
  }

  # Allow the node to access kube-apiserver
  cluster_security_group_additional_rules = {
    ingress_node_all = {
      description                = "Allow access from the node security group"
      protocol                   = "-1"
      from_port                  = 0
      to_port                    = 0
      type                       = "ingress"
      source_node_security_group = true
    }
    egress_all = {
      description = "Allow all egress within the VPC"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = [data.aws_vpc.app_vpc.cidr_block]
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    # Required for webhooks to work
    ingress_cluster_all = {
      description                   = "Cluster to node all ports/protocols"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_groups = {
    worker = {
      name           = "${local.cluster_name}-worker"
      name_prefix    = "${local.cluster_name}-worker"
      min_size       = var.worker_managed_node_group_min_size
      max_size       = var.worker_managed_node_group_max_size
      desired_size   = var.worker_managed_node_group_min_size
      instance_types = var.worker_managed_node_group_machine_types

      credit_specification = contains([for s in var.worker_managed_node_group_machine_types : can(regex("^t2", s))], true) ? {
        cpu_credits = "unlimited"
      } : {}

      capacity_type = "ON_DEMAND"
      update_config = {
        max_unavailable_percentage = 33 # or set `max_unavailable`
      }
    }
  }

  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
}

# The cluster security group is attached to all Fargate instances by default
# Ingress on Port 10250 is required to the metrics-server can collect metrics
resource "aws_security_group_rule" "metrics_server_ingress" {
  description              = "Allow port 10250 access from the VPC"
  security_group_id        = module.eks.cluster_primary_security_group_id
  protocol                 = "TCP"
  from_port                = 10250
  to_port                  = 10250
  type                     = "ingress"
  source_security_group_id = module.eks.node_security_group_id
}

# IAM policy to allow nodes to access ECR
# trivy:ignore:AVD-AWS-0057
resource "aws_iam_policy" "eks_ecr_access" {
  name = "${local.cluster_name}-eks-ecr-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Cluster KMS encryption key for secret encryption
module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.2.1"

  aliases               = ["eks/${local.cluster_name}"]
  description           = "${local.cluster_name} cluster encryption key"
  enable_default_policy = true

  key_service_roles_for_autoscaling = [
    # required for the ASG to manage encrypted volumes for nodes
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    # required for the cluster / persistentvolume-controller to create encrypted PVCs
    module.eks.cluster_iam_role_arn,
  ]
}
