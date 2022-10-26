terraform {
  backend "s3" {
    bucket = "mahterrabucket"
    key    = "simpleVPC.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
