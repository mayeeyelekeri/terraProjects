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
	default = "codeDeploy"
}

variable "key-file-name" { 
	default = "../../awsKeyPairDir/codeDeploy.pem"
}

variable "key-name" { 
	default = "codeDeploy"
}

variable "ec2-data" {
}