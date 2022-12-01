
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

