output "private_subnets_cidr" {
  value = aws_subnet.private_subnet[*].cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}
