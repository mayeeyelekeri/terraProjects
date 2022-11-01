terraform {
  backend "s3" {
    bucket = "mahterrabucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
