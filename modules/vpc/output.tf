output "vpc_arn" {
  description = "The ARN of the VPC."
  value       = module.vpc.vpc_arn
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "The name of the VPC."
  value       = module.vpc.name
}

output "private_route_table_id" {
  description = "ID for the route table associated with the private subnets."
  value       = try(module.vpc.private_route_table_ids[0], null)
}

output "private_subnets_ids" {
  description = "List of private subnets within VPC."
  value       = module.vpc.private_subnets
}

output "public_route_table_id" {
  description = "ID for the route table associated with the public subnets."
  value       = try(module.vpc.public_route_table_ids[0], null)
}

output "public_subnets_ids" {
  description = "List of public subnets within the VPC."
  value       = module.vpc.public_subnets
}
