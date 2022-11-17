terraform {
  backend "s3" {
    bucket = "codeDeploy"
    key    = "codeDeploy.tfstate"
    region = "us-east-1"
  }
  #required_version = ">= 1.3.3"
}

provider "aws" {
  region = "us-east-1"
}
