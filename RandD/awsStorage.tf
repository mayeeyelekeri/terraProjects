terraform {
  backend "s3" {
    bucket = "myterraprojects4"
    key    = "randd.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.3.3"
}


