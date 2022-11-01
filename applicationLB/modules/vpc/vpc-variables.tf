variable "region" {
  default = "us-east-1"
}

variable "open-cidr" {
	default = "0.0.0.0/0"
}

variable "vpc-cidr" {
	default = "10.0.0.0/16"
}

variable "public-subnet1-cidr" {
	default = "10.0.1.0/24"
}

variable "public-subnet2-cidr" {
	default = "10.0.2.0/24"
}

variable "public-subnet3-cidr" {
	default = "10.0.3.0/24"
}

variable "public-subnet1-name" {
	default = "MyPublicSubnet1"
}

variable "public-subnet2-name" {
	default = "MyPublicSubnet2"
}

variable "public-subnet3-name" {
	default = "MyPublicSubne3"
}

variable "availability-zone-1" {
	default = "us-east-1a"
}

variable "availability-zone-2" {
	default = "us-east-1b"
}

variable "availability-zone-3" {
	default = "us-east-1c"
}