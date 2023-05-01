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

variable "project-name" { 
	default = "applicationLBPrivatePublic"
}

variable "key-file-name-public" { 
	default = "~/.ssh/id_rsa.pub"
}

variable "key-file-name-private" { 
	default = "~/.ssh/id_rsa"
}

variable "key-name" { 
	default = "mykey"
}

variable "ec2-data" {
}