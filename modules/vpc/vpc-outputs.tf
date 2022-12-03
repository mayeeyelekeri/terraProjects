output "vpc_id" {
  description = "VPC ID created"
  value       = aws_vpc.vpc.id
}

output "vpc_name" {
  description = "VPC ID created"
  value       = aws_vpc.vpc.tags.Name
}

output "public_subnets" {
	value	  = values(aws_subnet.public)
} 

output "public" {
	value	  = aws_subnet.public
} 

output "private_subnets" {
	value	  = values(aws_subnet.private)

} 
output "public_sg_id" {
	value = aws_security_group.public_sg.id
}
