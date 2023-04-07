
/* --------------------------------------------
 Following actions are perfomed in "VPC" module
 1) Create VPC  
 2) Crete Internet gateway and attach it to VPC  
 3) Create Public subnets (by default its private)
 4) Create Route table and attach IG to it 
 5) Associate all public subnets to Route table 
 6) Create security group for public access 
 7) Create Private Subnets 
 8) Create Nat Gateway 
 9) Create Route table for private route 
 10) Associate route table to all Private subnets 
 11) Attach NAT gateway to all private route  
-------------------------------------------------------- */ 
module "vpc" {
    source = "../modules/vpc"
    
    # Pass all the variable values to the vpc module 
    aws_region         = var.aws_region
    open_cidr          = var.open_cidr 
    vpc_cidr           = var.vpc_cidr 
    public_subnet_map  = var.public_subnet_map
    private_subnet_map = var.private_subnet_map

    # ----- OUTPUTS ------ 
    # vpc_id,vpc_name, public_subnets, private_subnets, public_sg_id, private_sg_id, nat_gateway_id
}


/* --------------------------------------------
 Following actions are perfomed in "codebuild" module 
 1) New service Role for codebuild
 2) Create codebuild project 
 3) Initiate Build 
 4) Artifacts are copied to S3 bucket
-------------------------------------------------------- */ 
module "codebuild" { 
    source      = "./codebuild"

    codebucket_name               = var.codebucket_name
    git_creds                     = var.git_creds
    server_project_name           = var.server_project_name
    server_project_description    = var.server_project_description
    client_project_name           = var.client_project_name
    client_project_description    = var.client_project_description
    source_provider               = var.source_provider
} 

