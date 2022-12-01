# -------------- VPC outputs -----------------
output "vpc_vpc_id" {
  description = "VPC ID created"
  value       = module.vpc.vpc_id
}

output "vpc_public_sg_id" {
	value = module.vpc.public_sg_id
}

# ------------ ALB outputs -------------------

output "alb_tg_server_arn" { 
	value = module.alb.alb_tg_server_arn
}

output "alb_tg_client_arn" { 
	value = module.alb.alb_tg_client_arn
}

output "alb_server_dns" { 
	value = module.alb.alb_server_dns
}

output "alb_client_dns" { 
	value = module.alb.alb_client_dns
}