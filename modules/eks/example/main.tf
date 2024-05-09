locals {
  aws_region  = "eu-west-2"
  environment = "development"
}

# trivy:ignore:AVD-AWS-0038
module "eks" {
  source = "../../../modules/eks"

  name            = "test"
  cluster_version = "1.29"

  environment = local.environment
  subnet_ids  = data.aws_subnets.eks_private_subnets.ids
  aws_region  = local.aws_region
  vpc_id      = data.aws_vpc.test_vpc.id

  enabled_log_types = ["authenticator", "controllerManager", "scheduler", "api", "audit"]

  worker_managed_node_group_machine_types = ["t3.large"]
}

data "aws_vpc" "test_vpc" {
  filter {
    name   = "tag:Name"
    values = ["test-vpc"]
  }
}

data "aws_subnets" "eks_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.test_vpc.id]
  }

  tags = {
    SubnetType = "private"
  }
}

