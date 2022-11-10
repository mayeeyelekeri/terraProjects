output "VPC-ID" {
  description = "VPC Id"
  value       = aws_vpc.myvpc.id
}

output "public-subnets" {
	value = values(aws_subnet.public-subnets)[*].id
}