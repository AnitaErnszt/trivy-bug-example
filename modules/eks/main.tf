

locals {
  cluster_name = join("-", ["eks", var.environment])

  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}
