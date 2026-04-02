output "public_subnets_cidr" {
  value = aws_subnet.public_subnet[*].cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}
