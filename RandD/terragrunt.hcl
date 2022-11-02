# Indicate where to source the terraform module from.
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=3.5.0".
# Note the extra `/` after the protocol is required for the shorthand
# notation.
terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=3.5.0"
}

# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "myterraprojects"
    key    = "randd.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.3.3"
}
EOF
}

# Indicate the input values to use for the variables of the module.
inputs = {
  vpc-cidr = "10.0.0.0/16"

vpc2-cidr = "192.168.0.0/16"

public-subnet-cidr-list = ["10.0.1.0/24" , "10.0.2.0/24"]
public-subnet-availability-zone-list = ["us-east-1a" , "us-east-1b"]

private-subnet-map = { "10.0.3.0/24" = "us-east-1a" 
					   "10.0.4.0/24" = "us-east-1b" }

private-subnet2-map = { "public1" = { cidr = "10.0.5.0/28", zone = "us-east-1a" },  
					    "public2" = { cidr = "10.0.6.0/28", zone = "us-east-1b" }, 
						"public3" = { cidr = "10.0.7.0/28", zone = "us-east-1c" },  
					    "public4" = { cidr = "10.0.8.0/28", zone = "us-east-1d" }
					  }

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}