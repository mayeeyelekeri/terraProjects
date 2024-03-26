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

# ------------ CodeBuild outputs -------------------
 
output "codebuild_bucket_id" { 
	value = module.codebuild.codebuild_bucket_id
}  


# ------------ ALB outputs -------------------
 
output "alb_tg_arn" { 
	value = module.alb.alb_tg_arn
}

output "alb_dns" { 
	value = module.alb.alb_dns
}


  
# ----------- Autoscaling --------------------
output "auto_scale_group_name" { 
	value = module.autoscale.autoscaling_group_name
}
