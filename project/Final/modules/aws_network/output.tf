# Add output variables
output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}


output "vpc_route_table_id" {
  description = "The ID of the main route table of the VPC."
  value       = data.aws_route_table.main.id
}

output "public_subnet_route_table_id" {
  value  = length(aws_route_table.public_route_table) > 0 ? aws_route_table.public_route_table[0].id : null
  description = "ID of the public subnet route table, if it exists"
}


output "private_subnet_route_table_id"{
  value  = aws_route_table.private_route_table.id
}

