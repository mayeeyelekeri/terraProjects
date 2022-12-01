output "vpc_id" {
  description = "VPC ID created"
  value       = module.vpc.vpc_id
}

output "public_sg" {
	value = module.vpc.public_sg
}

output "public_sg_id" {
	value = module.vpc.public_sg_id
}
