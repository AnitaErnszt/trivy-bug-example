data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

# Used to figure out which subnets are in which availability zones
data "aws_subnet" "selected" {
  for_each = toset(var.subnet_ids)

  id = each.value
}

data "aws_vpc" "app_vpc" {
  id = var.vpc_id
}
