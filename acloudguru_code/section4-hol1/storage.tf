terraform {
  backend "s3" { 
	bucket = "mahterrabucket" 
	key    = "terra.state"
	region = "us-east-1"
  }
}
