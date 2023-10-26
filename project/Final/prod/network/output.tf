output "private_subnet_id" {
  value = module.vpc-prod.private_subnet_id
}

output "vpc_id" {
  value = module.vpc-prod.vpc_id
}

output "prod_main_route_table_id" {
  value       = module.vpc-prod.vpc_route_table_id
}


output "private_subnet_route_table_id"{
  value  = module.vpc-prod.private_subnet_route_table_id
}