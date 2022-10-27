terraform {
  backend "s3" {
    bucket = "myterraprojects1"
    key    = "simpleVPC.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.3.3"
}

provider "aws" {
  region = "us-east-1"
}
