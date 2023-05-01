variable "ami-id" {
  default = "ami-09d3b3274b6c5d4aa"
}

variable "instance-type" {
	default = "t3.micro"
}

variable "key-pair-path" { 
	default = "../../awsKeyPairDir"
}

variable "project-name" { 
	default = "ec2PublicPrivate"
}

variable "key-file-name-private" { 
	default = "~/.ssh/id_rsa"
}

variable "key-file-name-public" { 
	default = "~/.ssh/id_rsa.pub"
}

variable "key-name" { 
	default = "keyname"
}