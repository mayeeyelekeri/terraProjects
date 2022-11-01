variable "ami" {
  default = "ami-09d3b3274b6c5d4aa"
}

variable "instance-type" {
	default = "t3.micro"
}

variable "key-pair-path" { 
	default = "../../awsKeyPairDir"
}

variable "project_name" { 
	default = "ec2PublicPrivate"
}

variable "key_file_name" { 
	default = "../../awsKeyPairDir/ec2PublicPrivate.pem"
}

variable "key_name" { 
	default = "ec2PublicPrivate"
}

variable "ami_id" {
	default = "ami-09d3b3274b6c5d4aa"
}
