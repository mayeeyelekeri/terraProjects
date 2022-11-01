variable "aws_region" {
  default = "us-east-1"
}

variable "open-cidr" {
	default = "0.0.0.0/0"
}

variable "vpc-cidr" {
	default = "10.0.0.0/16"
}

variable "public-subnet-cidr" {
	default = "10.0.1.0/24"
}

variable "public-subnet-name" {
	default = "MyPublicSubnet"
}

variable "private-subnet-cidr" {
	default = "10.0.2.0/24"
}

variable "private-subnet-name" {
	default = "MyPrivateSubnet"
}

variable "availability-zone-a" {
	default = "us-east-1a"
}

variable "availability-zone-b" {
	default = "us-east-1b"
}