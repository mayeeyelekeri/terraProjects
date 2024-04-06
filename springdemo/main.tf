
/* --------------------------------------------
 Following actions are perfomed in "VPC" module
 1) Create VPC  
 2) Create Internet gateway and attach it to VPC  
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
 2) New S3 bucket to copy artifacts 
 3) Create codebuild projects 
 4) Initiate Builds 
    *** Build commands are inside buildspec.yml file, in the source code main dir. 
 5) Build Artifacts are copied to S3 bucket 
-------------------------------------------------------- */ 
 module "codebuild" { 
    source      = "./codebuild"

    buildbucket_name              = var.buildbucket_name
    git_creds                     = var.git_creds
    project_name                  = var.app_name
    project_description           = var.project_description
    source_provider               = var.source_provider
}   

/* --------------------------------------------
 Following actions are perfomed in "ALB"" module for both client and server 
 1) Create Load balancer target group 
 2) Create Application Load Balancer 
 3) Create Listener and attach it to ALB 
-------------------------------------------------------- */ 
# Create Application Load Balancer 
module "alb" {
    source = "./alb"

    # all these information coming VPC module 
    vpc_id                = module.vpc.vpc_id
    public_sg_id          = module.vpc.public_sg_id
    public_subnets        = module.vpc.public_subnets

    application_port      = var.application_port
    app_health_check_path = var.app_health_check_path

    # ------ OUTPUTS ------ 
    # alb_tg_arn, alb_dns
}

/* --------------------------------------------
 Following actions are perfomed in "autoscaling" module 
 1) Import local key to AWS 
 2) Create an Instance profile for EC2 
 3) Create Launch configuration based on Amazon Linux ami
    Attach instanceprofile 
    Add "user_data" to install docker and codedeploy agent 

 4) Create Auto-scaling group (**** for both client and server)
    Attach launch configuration
    Attach target group created in ALB module 
-------------------------------------------------------- */ 
module "autoscale" {
    source = "./autoscale"

    app_name              = var.app_name
    key_name              = var.key_name 
    ami_id                = var.ami_id 
    instance_type         = var.instance_type 
    instance_profile_name = var.instance_profile_name
    autoscale_min         = var.autoscale_min 
    autoscale_max         = var.autoscale_max 
    autoscale_desired     = var.autoscale_desired
    template_name         = var.template_name

    # from VPC module 
    public_sg_id          = module.vpc.public_sg_id
    public_subnets        = module.vpc.public_subnets
    private_sg_id         = module.vpc.public_sg_id
    private_subnets       = module.vpc.private_subnets
    
    # from ALB module 
    alb_tg_arn            = module.alb.alb_tg_arn     

    # ------ OUTPUTS ------ 
    #  auto_scale_group_name
}  

/* --------------------------------------------
 Following actions are perfomed in "codedeploy" module 
 1) New codedeploy bucket (random postfix)
 2) Instance profile for codedeploy 

 **** Below tasks are performed for both client and server 

 3) Create codedeploy application 
 4) Create codedeploy deployment group 
 5) Upload file to bucket 
 6) Initiate deploy 
-------------------------------------------------------- */ 
module "codedeploy" { 
    source      = "./codedeploy"

    app_name                      = var.app_name 
    zip_file                      = var.zip_file
    
    # from ALB module 
    alb_dns                       = module.alb.alb_dns

    # from autoscaling module 
    autoscaling_group_name         = module.autoscale.autoscaling_group_name
    
    # from codebuild module 
    codebucket_name               = module.codebuild.codebuild_bucket_id
             
    depends_on = [module.autoscale, module.alb, module.codebuild]
} 

/* --------------------------------------------
 Following actions are perfomed in "codedeploy" module 
 1) New codepipeline bucket (random postfix)
 2) Instance profile for codepipeline 
 3) Create codepipeline application 
-------------------------------------------------------- */ 
/* module "codepipeline" { 
    source      = "./codepipeline"

    pipeline_name            = var.app_name 
    pipeline_bucket          = "codepipeline"
    project_name             = var.app_name
    git_creds                = var.git_creds

    # Codedeploy related values 
    deploy_group_name        = "springdemo2-deploygroup"
             
    depends_on = [module.codedeploy]
} */ 

/* --------------------------------------------
 Following actions are perfomed in "ElasticBeanStalk" module 
 1) New BeanStalk application
 2) Create beanstalk profile role  
 3) Create Environment 
 4) Start Deployment
-------------------------------------------------------- */ 
module "beanstalk" { 
    source      = "./beanstalk"

    app_name               = var.app_name 
    bucket_name            = module.codebuild.codebuild_bucket_id
    file_name              = var.file_name 
    instance_profile_name  = var.instance_profile_name

    # Codebuild values 
    stack_name             = var.stack_name
                 
    # VPC Module 
    security_group         = module.vpc.public_sg_id
    vpc_id                 = module.vpc.vpc_id 
    public_subnets         = module.vpc.public_subnets[0].id

    depends_on             = [module.codebuild]
} 
