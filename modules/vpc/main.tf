locals {
  default_egress_rule = [{
    rule_number = 100
    rule_action = "allow"
    cidr_block  = "0.0.0.0/0"
    protocol    = "all"
    from_port   = 0
    to_port     = 0
  }]

  has_public_subnets  = length(var.public_subnets.list) > 0
  has_private_subnets = length(var.private_subnets.list) > 0
}

# trivy:ignore:AVD-AWS-0164
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs = var.vpc_azs

  ################################
  # Private subnets & networking #
  ################################
  private_subnets      = var.private_subnets.list
  private_subnet_names = [for idx, private_subnet in var.private_subnets.list : "${var.vpc_name}-private-${idx + 1}"]

  # Create a dedicated NACL if private subnets exist
  # NACL rules are defined outside the public Terraform module, in order to use for_each instead of count
  private_dedicated_network_acl = local.has_private_subnets ? true : false
  private_acl_tags = {
    Name = "nacl-${var.vpc_name}-private-subnets"
  }
  private_inbound_acl_rules  = []
  private_outbound_acl_rules = []

  ###############################
  # Public subnets & networking #
  ###############################
  public_subnets      = var.public_subnets.list
  public_subnet_names = [for idx, public_subnet in var.public_subnets.list : "${var.vpc_name}-public-${idx + 1}"]

  # Create a dedicated NACL if private subnets exist
  # NACL rules are defined outside the public Terraform module, in order to use for_each instead of count
  public_dedicated_network_acl = local.has_public_subnets ? true : false
  public_inbound_acl_rules  = []
  public_outbound_acl_rules = []

  #######
  # IGW #
  #######
  # Only create Internet Gateway if public subnets exist
  create_igw = local.has_public_subnets

  #######
  # NAT #
  #######
  # Only create NAT if `enable_nat_gateway` AND the VPC has public subnets
  enable_nat_gateway     = local.has_public_subnets && var.enable_nat_gateway
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  #######
  # DNS #
  #######
  enable_dns_support   = true
  enable_dns_hostnames = true

  #################
  # VPC Flow logs #
  #################
  enable_flow_log = true
  # All VPC flow logs should be sent to the `custom-logs` bucket
  flow_log_destination_arn          = "arn:aws:s3:::custom-logs"
  flow_log_destination_type         = "s3"
  flow_log_file_format              = "plain-text"
  flow_log_per_hour_partition       = true
  flow_log_max_aggregation_interval = "600"
  flow_log_traffic_type             = "ALL"

  ##########
  # Others #
  ##########
  # This route table is created when the VPC is created. We're
  # simply updating its tags to provide a more human readable name.
  default_route_table_name      = "${var.vpc_name}-default"
  manage_default_route_table    = true
  manage_default_network_acl    = false
  manage_default_security_group = false
  map_public_ip_on_launch       = true
}

# Deny all traffic in the Default ACL to force all resources to assign a non-default ACL.
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl#example-deny-all-traffic-to-any-subnet-in-the-default-network-acl
resource "aws_default_network_acl" "default_nacl" {
  default_network_acl_id = module.vpc.default_network_acl_id

  # no rules defined, deny all traffic in this ACL
}

resource "aws_network_acl_rule" "private_inbound" {
  for_each = { for nacl_rule in var.private_subnets.inbound_acl_rules : nacl_rule.rule_number => nacl_rule }

  network_acl_id = module.vpc.private_network_acl_id
  egress         = false

  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  cidr_block  = each.value.cidr_block
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
}

resource "aws_network_acl_rule" "private_outbound" {
  for_each = local.has_private_subnets ? { for nacl_rule in(length(var.private_subnets.outbound_acl_rules) > 0 ? var.private_subnets.outbound_acl_rules : local.default_egress_rule) : nacl_rule.rule_number => nacl_rule } : {}

  network_acl_id = module.vpc.private_network_acl_id
  egress         = true

  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  cidr_block  = each.value.cidr_block
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
}

resource "aws_network_acl_rule" "public_inbound" {
  for_each = { for nacl_rule in var.public_subnets.inbound_acl_rules : nacl_rule.rule_number => nacl_rule }

  network_acl_id = module.vpc.public_network_acl_id
  egress         = false

  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  cidr_block  = each.value.cidr_block
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
}

resource "aws_network_acl_rule" "public_outbound" {
  for_each = local.has_public_subnets ? { for rule in(length(var.private_subnets.outbound_acl_rules) > 0 ? var.private_subnets.outbound_acl_rules : local.default_egress_rule) : rule.rule_number => rule } : {}

  network_acl_id = module.vpc.public_network_acl_id
  egress         = true

  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  cidr_block  = each.value.cidr_block
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
}
