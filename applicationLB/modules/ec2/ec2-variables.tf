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
	default = "applicationLB"
}

variable "key_file_name" { 
	default = "../../awsKeyPairDir/applicationLB.pem"
}

variable "key_name" { 
	default = "applicationLB"
}

variable "ami_id" {
	default = "ami-09d3b3274b6c5d4aa"
}
