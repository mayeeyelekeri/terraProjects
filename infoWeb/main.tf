
/* --------------------------------------------
 Following actions are performed in "VPC" module
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
 Following actions are performed in "AMI" module 
 1) Create and EC2 instance  
 2) Once the instance is created, generate and AMI from that 
-------------------------------------------------------- */
module "ami" {
  source = "../modules/ami"

  key_name              = var.key_name
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  instance_profile_name = var.instance_profile_name

  # from VPC module 
  public_sg_id    = module.vpc.public_sg_id
  public_subnets  = module.vpc.public_subnets

  # ------ OUTPUTS ------ 
  # docker_ami_id 
}


/* --------------------------------------------
 Following actions are perfomed in "codebuild" module 
 1) New service Role for codebuild
 2) New S3 bucket to copy artifacts 
 3) Create codebuild projects (both client and server )
 4) Initiate Builds (first server and then client)
    *** Build commands are inside buildspec.yml file, in the source code main dir. 
 5) Build Artifacts are copied to S3 bucket 
-------------------------------------------------------- */
module "codebuild" {
  source = "../modules/codebuild"

  state_bucket_name          = var.state_bucket
  buildbucket_name           = var.buildbucket_name
  git_creds                  = var.git_creds
  server_project_name        = var.server_project_name
  server_project_description = var.server_project_description
  client_project_name        = var.client_project_name
  client_project_description = var.client_project_description
  source_provider            = var.source_provider

  # from alb (this is required to perform client build)
  alb_server_dns = module.alb.alb_server_dns
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
  application_port      = var.info_client_port
  app_health_check_path = var.app_health_check_path

  # ------ OUTPUTS ------ 
  # alb_tg_server_arn, alb_tg_client_arn, alb_server_dns, alb_client_dns
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

  app_name_server       = var.app_name_server
  app_name_client       = var.app_name_client
  key_name              = var.key_name
  #ami_id                = var.ami_id
  ami_id                = module.ami.docker_ami_id
  instance_type         = var.instance_type
  instance_profile_name = var.instance_profile_name
  autoscale_min         = var.autoscale_min
  autoscale_max         = var.autoscale_max
  autoscale_desired     = var.autoscale_desired
  template_name_server  = var.template_name_server
  template_name_client  = var.template_name_client

  # from VPC module 
  public_sg_id    = module.vpc.public_sg_id
  public_subnets  = module.vpc.public_subnets
  private_sg_id   = module.vpc.public_sg_id
  private_subnets = module.vpc.private_subnets

  # from ALB module 
  alb_tg_server_arn = module.alb.alb_tg_server_arn
  alb_tg_client_arn = module.alb.alb_tg_client_arn

  # ------ OUTPUTS ------ 
  #  auto_scale_group_name_client, auto_scale_group_name_server 
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
  source = "../modules/codedeploy"

  codebucket_name            = module.codebuild.codebuild_bucket_id
  app_name_server            = var.app_name_server
  app_name_client            = var.app_name_client
  zip_file_server            = var.zip_file_server
  zip_file_client            = var.zip_file_client
  webapp_src_location_server = var.webapp_src_location_server
  webapp_src_location_client = var.webapp_src_location_client
  server_project_name        = var.server_project_name
  client_project_name        = var.client_project_name

  # from autoscaling module 
  auto_scale_group_name_client = module.autoscale.auto_scale_group_name_client
  auto_scale_group_name_server = module.autoscale.auto_scale_group_name_server

  # Not sure it works 
  # These variables are not being used in the module, created to make a dependency on "alb" and "build" module 
  # Because, deploy to client is happening before the "mvm package", so its picking up old client.jar file 
  # alb_server_dns                = module.alb.alb_server_dns
  # create_client_package_id      = module.build.create_client_package_id

  #  from ALB module 
  alb_server_dns = module.alb.alb_server_dns

  depends_on = [module.autoscale, module.alb, module.codebuild]
}

