variable "ami-id" {
  default = "ami-09d3b3274b6c5d4aa"
}

variable "ami-id-ubuntu" {
  default = "ami-09d3b3274b6c5d4aa"
}

variable "myimage" {
  default = "ami-09d3b3274b6c5d4aa"
}

variable "instance-type" {
	default = "t3.micro"
}

variable "key-pair-path" { 
	default = "../../awsKeyPairDir"
}

variable "project-name" { 
	default = "applicationLBPrivatePublic"
}

variable "key-file-name" { 
	default = "../../awsKeyPairDir/applicationLBPrivatePublic.pem"
}

variable "key-name" { 
	default = "applicationLBPrivatePublic"
}

variable "ec2-data" {}
variable "docker-file" {}
variable "image-name" {}
variable "war-file" {}