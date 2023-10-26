output "public_subnet_ids" {
  value = module.vpc-staging.public_subnet_ids
}

output "private_subnet_id" {
  value = module.vpc-staging.private_subnet_id
}

output "vpc_id" {
  value = module.vpc-staging.vpc_id
}

output "staging_main_route_table_id" {
  description = "The ID of the main route table of the staging environment VPC."
  value       = module.vpc-staging.vpc_route_table_id
}

output "public_subnet_route_table_id"{
  value  = module.vpc-staging.public_subnet_route_table_id
}