locals {
  vpc_cidr = "10.0.0.0/16"
  service     = "example"
  environment = "development"
}

# trivy:ignore:AVD-AWS-0102
# trivy:ignore:AVD-AWS-0105
module "test_vpc" {
  source = "../../vpc"

  vpc_cidr = local.vpc_cidr
  vpc_name = "test-vpc"
  vpc_azs  = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

  public_subnets = {
    list = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"],
    inbound_acl_rules = [
      { rule_number = 10, protocol = "all", from_port = 0, to_port = 0, cidr_block = local.vpc_cidr, rule_action = "allow" },
      { rule_number = 40, protocol = "tcp", from_port = 443, to_port = 443, cidr_block = "0.0.0.0/0", rule_action = "allow" },
    ]
    outbound_acl_rules = [
      # NACLs are stateless, so if no outbound rule defined, by default, it'll block all outbound traffic.
      # To make configuration of rules easier, if no rules are defined the module will add an outbound rule to allow all traffic.
    ]
  }

  private_subnets = {
    list = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"],
    inbound_acl_rules = [
      { rule_number = 10, protocol = "all", from_port = 0, to_port = 0, cidr_block = local.vpc_cidr, rule_action = "allow" },
      # Response traffic from public internet through NAT gateway over ephemeral ports
      { rule_number = 900, protocol = "tcp", from_port = 1024, to_port = 65535, cidr_block = "0.0.0.0/0", rule_action = "allow" }
    ]
    ooutbound_acl_rules = [
      # NACLs are stateless, so if no outbound rule defined, by default, it'll block all outbound traffic.
      # To make configuration of rules easier, if no rules are defined the module will add an outbound rule to allow all traffic.
    ]
  }
}
