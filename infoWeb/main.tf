module "vpc" {
    source = "./vpc"

    # Pass all the variable values to the vpc module 
    aws_region        = var.aws_region
    open_cidr         = var.open_cidr 
    vpc_cidr          = var.vpc_cidr 
    public_subnet_map = var.public_subnet_map

    # ----- OUTPUTS ------ 
    # vpc_id, public_subnets, vpc_name, public_sg 
}

module "alb" {
    source = "./alb"

    vpc_id         = "${module.vpc.vpc_id}" 
    public_sg      = "${module.vpc.public_sg}" 
    public_subnets = "${module.vpc.public_subnets}"
}
