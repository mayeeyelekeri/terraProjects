variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc-cidr" {
	type	= string
	default = "10.0.0.0/16"
}

variable "subnet-cidr" {
	type	= string
	default = "10.0.1.0/24"
}
