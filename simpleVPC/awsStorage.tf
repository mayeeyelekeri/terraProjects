terraform {
  backend "s3" {
    bucket = "myterraprojects1"
    key    = "simpleVPC.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
