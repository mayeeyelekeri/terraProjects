terraform {
  backend "s3" {
    bucket = "myterraprojects"
    key    = "ec2PublicPrivate.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.3.3"
}

provider "aws" {
  region = "us-east-1"
}
