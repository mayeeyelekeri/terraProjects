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
	value = values(module.vpc.public)
}

# ------------ ALB outputs -------------------

/* output "alb_tg_server_arn" { 
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

# ----------- Autoscaling --------------------
output "autoscale-auto_scale_group_name_server" { 
	value = module.autoscale.auto_scale_group_name_server
}

output "scaling-auto_scale_group_name_client" { 
	value = module.autoscale.auto_scale_group_name_client
} */