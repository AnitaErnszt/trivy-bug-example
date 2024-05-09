module "eks" {
  source = "./modules/eks"

  name            = local.service
  cluster_version = "1.29"

  environment       = local.environment
  subnet_ids        = module.test_vpc.private_subnets_ids
  aws_region        = local.aws_region
  vpc_id            = module.test_vpc.vpc_id

  enabled_log_types = ["authenticator", "controllerManager", "scheduler"]

  worker_managed_node_group_machine_types = ["t3.medium"]
}
