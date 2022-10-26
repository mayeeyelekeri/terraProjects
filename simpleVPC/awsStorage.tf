terraform {
  backend "s3" {
    bucket = "myterraprojects"
    key    = "simpleVPC.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
