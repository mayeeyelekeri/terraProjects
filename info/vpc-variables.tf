variable "aws_region" {
  default = "us-east-1"
}

variable "open-cidr" {
	default = "0.0.0.0/0"
}

variable "vpc-cidr" {
	default = "10.0.0.0/16"
}

variable "public-subnets" {
}

variable "private-subnets" {
}