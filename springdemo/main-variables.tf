
# VPC related 
variable "aws_region" {}
variable "open_cidr" {}
variable "vpc_cidr" {}
variable "public_subnet_map" {}
variable "private_subnet_map" {}
variable "state_bucket" {} 


/* 
# ALB related 
#variable "app_health_check_path" {} 

# Autoscaling 
variable "app_name" {}
variable "key_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "instance_profile_name" {}
variable "autoscale_min" {} 
variable "autoscale_max" {}
variable "autoscale_desired" {}
variable "app_health_check_path" {}
variable "template_name" {}


# Code Deploy 
variable "codebucket_name" {}
variable "zip_file" {}
variable "webapp_src_location" {}
variable "auto_scale_group_name" {}

# Build 
variable "war_file" {}
#variable "app_name" {}
#variable "zip_file" {}
variable "docker_file" {}
variable "jar_file" {}
variable "info_server_workspace" {} 

variable "dest_properties_file" {}
variable "springboot_workspace" {} 
variable "src_properties_file" {}
variable "springboot_port" {} 

# Codebuild 
variable "git_creds" {}
variable "project_name" {} 
variable "project_description" {} 
variable "source_provider" {}
variable "buildbucket_name" {} */  
