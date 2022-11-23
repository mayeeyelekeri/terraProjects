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

variable "docker-file-client" {}
variable "image-name-client" {}
variable "war-file-client" {}
variable "db-name" {} 
variable "mysql-port" {}
variable "mysql-user" {}
variable "mysql-password" {}
variable "mysql-host" {}
variable "mysql-database" {}
variable "src-properties-file" {}
variable "dest_properties_file" {}