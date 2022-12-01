
# VPC related 
variable "aws_region" {}
variable "open_cidr" {}
variable "vpc_cidr" {}
variable "public_subnet_map" {}

# ALB related 
#variable "public_subnets" {}

# Autoscaling 
variable "app_name_server" {}
variable "app_name_client" {}
variable "key_name" {}
variable "ami_id" {}
variable "instance_type" {}

# Code Deploy 
variable "codebucket_name" {}
#variable "app_name_server" {}
#variable "app_name_client" {}
variable "zip_file_server" {}
variable "zip_file_client" {}
variable "webapp_src_location_server" {}
variable "webapp_src_location_client" {}
#variable "auto_scale_group_name_server" {}
#variable "auto_scale_group_name_client" {}

