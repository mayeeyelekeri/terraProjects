# -------------- VPC outputs -----------------
output "vpc-vpc_id" {
  description = "VPC ID created"
  value       = module.vpc.vpc_id
}

output "vpc-public_sg_id" {
	value = module.vpc.public_sg_id
}

output "public-subnet-ids" { 
	value = module.vpc.public_subnets[*].id
}

output "public" { 
	value = values(module.vpc.public)[*].cidr_block
}

output "nat_gateway_id" { 
	value = module.vpc.nat_gateway_id
} 

