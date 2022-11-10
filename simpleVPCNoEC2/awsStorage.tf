terraform {
  backend "s3" {
    bucket = "myterraprojects4"
    key    = "simplevpcnoec2.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.3.3"
}

provider "aws" {
  region = "us-east-1"
}
