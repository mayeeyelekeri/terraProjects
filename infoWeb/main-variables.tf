
# VPC related 
variable "aws_region" {}
variable "open_cidr" {}
variable "vpc_cidr" {}
variable "public_subnet_map" {}
variable "private_subnet_map" {}
variable "state_bucket" {}


# ALB related 
#variable "app_health_check_path" {} 

# Autoscaling 
variable "app_name_server" {}
variable "app_name_client" {}
variable "key_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "instance_profile_name" {}
variable "autoscale_min" {}
variable "autoscale_max" {}
variable "autoscale_desired" {}
variable "app_health_check_path" {}
variable "template_name_server" {}
variable "template_name_client" {}


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

# Build 
variable "war_file_server" {}
#variable "app_name_server" {}
#variable "zip_file_server" {}
variable "docker_file_server" {}
variable "dest_properties_file_server" {}
variable "jar_file_server" {}
variable "info_server_workspace" {}

variable "war_file_client" {}
#variable "app_name_client" {}
#variable "zip_file_client" {}
variable "docker_file_client" {}
variable "dest_properties_file_client" {}
variable "jar_file_client" {}
variable "info_client_workspace" {}
variable "src_properties_file_client" {}
variable "src_properties_file_server" {}
variable "mysql_creds" {}
variable "info_client_port" {}

# Codebuild 
variable "git_creds" {}
variable "server_project_name" {}
variable "server_project_description" {}
variable "client_project_name" {}
variable "client_project_description" {}
variable "source_provider" {}
variable "buildbucket_name" {}

# CodeArtifact 
variable "codeartifact_domain_name" {}
variable "repo_name" {}
