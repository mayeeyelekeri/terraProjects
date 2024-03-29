terraform {
  backend "s3" {
    bucket = "terraprojects"
    key    = "codePipeline.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.4.1"
}

provider "aws" {
  region = "us-east-1"
}
