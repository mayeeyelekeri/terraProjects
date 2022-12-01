terraform {
  backend "s3" {
    bucket = "terraprojects7"
    key    = "infoweb.tfstate"
    region = "us-east-1"
  }
  #required_version = ">= 1.3.3"
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
    source = "./vpc"

    # Pass all the variable values to the vpc module 
    aws_region        = var.aws_region
    open_cidr         = var.open_cidr 
    vpc_cidr          = var.vpc_cidr 
    public_subnet_map = var.public_subnet_map
}
