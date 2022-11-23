variable "ami_id" {
  default = "ami-09d3b3274b6c5d4aa"
}

variable "ami_id_ubuntu" {
  default = "ami-09d3b3274b6c5d4aa"
}

variable "myimage" {
  default = "ami-09d3b3274b6c5d4aa"
}

variable "instance_type" {
	default = "t3.micro"
}

variable "key_pair_path" { 
	default = "../../awsKeyPairDir"
}

variable "project_name" { 
	default = "applicationLBPrivatePublic"
}

variable "key_file_name" { 
	default = "../../awsKeyPairDir/applicationLBPrivatePublic.pem"
}

variable "key_name" { 
	default = "applicationLBPrivatePublic"
}

variable "ec2_data" {}
variable "docker_file" {}
variable "image_name" {}
variable "war_file" {}

variable "docker_file_client" {}
variable "image_nameclient" {}
variable "war_file_client" {}
variable "db_name" { default = "infodb"} 
variable "mysql_port" {}
variable "mysql_user" {}
variable "mysql_password" {}
variable "mysql_host" {}
variable "mysql_database" {}
variable "src_properties_file" {}
variable "dest_properties_file" {}
variable "info_server_port" {}
variable "info_client_workspace" {}
variable "info_server_workspace" {}
variable "dbdump_file" {}