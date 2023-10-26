# Step 10 - Add output variables
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_ips" {
  value       = aws_instance.my_amazon.private_ip
}
