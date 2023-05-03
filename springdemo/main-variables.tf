
# VPC related 
variable "aws_region" {}
variable "open_cidr" {}
variable "vpc_cidr" {}
variable "public_subnet_map" {}
variable "private_subnet_map" {}

# ALB related 
#variable "app_health_check_path" {} 

# Autoscaling 
variable "app_name_server" {}
variable "key_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "instance_profile_name" {}
variable "autoscale_min" {} 
variable "autoscale_max" {}
variable "app_health_check_path" {}
variable "template_name_server" {}

# Code Deploy 
variable "codebucket_name" {}
variable "zip_file_server" {}
variable "webapp_src_location_server" {}

# Build 
variable "war_file_server" {}
#variable "app_name_server" {}
#variable "zip_file_server" {}
variable "docker_file_server" {}
variable "dest_properties_file_server" {}
variable "jar_file_server" {}
variable "info_server_workspace" {} 

variable "src_properties_file_server" {}
variable "mysql_creds" {}

# Codebuild 
variable "git_creds" {}
variable "server_project_name" {} 
variable "server_project_description" {} 
variable "source_provider" {}
variable "buildbucket_name" {}