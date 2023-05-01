terraform {
  backend "s3" {
    bucket = "myterraprojects2"
    key    = "codePipeline.tfstate"
    region = "us-east-1"
  }
  required_version = "= 1.4.6"
}

provider "aws" {
  region = "us-east-1"
}
