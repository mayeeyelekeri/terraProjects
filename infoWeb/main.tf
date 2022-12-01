module "vpc" {
    source = "./vpc"

    # Pass all the variable values to the vpc module 
    aws_region        = var.aws_region
    open_cidr         = var.open_cidr 
    vpc_cidr          = var.vpc_cidr 
    public_subnet_map = var.public_subnet_map

    # ----- OUTPUTS ------ 
    # vpc_id, public_subnets, vpc_name, public_sg_id 
}

module "alb" {
    source = "./alb"

    vpc_id         = module.vpc.vpc_id
    public_sg_id   = module.vpc.public_sg_id
    public_subnets = module.vpc.public_subnets

    # ------ OUTPUTS ------ 
    # alb_tg_server_arn, alb_tg_client_arn, alb_server_dns, alb_client_dns
}

module "autoscale" {
    source = "./autoscale"

    public_sg_id      = module.vpc.public_sg_id
    public_subnets    = module.vpc.public_subnets
    app_name_server   = var.app_name_server
    app_name_client   = var.app_name_client 
    alb_tg_server_arn = module.alb.alb_tg_server_arn 
    alb_tg_client_arn = module.alb.alb_tg_client_arn 
    key_name          = var.key_name 
    ami_id            = var.ami_id 
    instance_type     = var.instance_type 

    # ------ OUTPUTS ------ 
    #  
}


module "codedeploy" { 
    source      = "./codedeploy"

    codebucket_name               = var.codebucket_name
    app_name_server               = var.app_name_server 
    app_name_client               = var.app_name_client 
    zip_file_server               = var.zip_file_server
    zip_file_client               = var.zip_file_client
    auto_scale_group_name_client  = module.autoscale.auto_scale_group_name_client
    auto_scale_group_name_server  = module.autoscale.auto_scale_group_name_server
    webapp_src_location_server    = var.webapp_src_location_server
    webapp_src_location_client    = var.webapp_src_location_client
    
} 

module "build" {
    source     = "./build"

    mysql_creds          = var.mysql_creds
    src_properties_file_server   = var.src_properties_file_server
    dest_properties_file_server  = var.dest_properties_file_server
    webapp_src_location_server   = var.webapp_src_location_server
    info_server_workspace        = var.info_server_workspace
}