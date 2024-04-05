
# VPC related 
variable "aws_region" {}
variable "open_cidr" {}
variable "vpc_cidr" {}
variable "public_subnet_map" {}
variable "private_subnet_map" {}
variable "state_bucket" {} 

# Codebuild 
variable "git_creds" {}
#variable "project_name" {} 
variable "project_description" {} 
variable "source_provider" {}
variable "buildbucket_name" {}   


# ALB related 
variable "app_health_check_path" {} 
variable "application_port" {} 

# Autoscaling 
variable "app_name" {}
variable "key_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "instance_profile_name" {}
variable "autoscale_min" {} 
variable "autoscale_max" {}
variable "autoscale_desired" {}
variable "template_name" {}


# Code Deploy 
variable "zip_file" {}

# Elastic Bean Stalk
variable "stack_name" {} 
variable "file_name" {}