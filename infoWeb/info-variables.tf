variable "ami_id" {
  default = "ami-09d3b3274b6c5d4aa"
}
variable "client_image" { default = "ami-0a38b61fdbcd06e9b"} 

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

variable "docker_file" {}
variable "image_name" {}
variable "war_file" {}

variable "docker_file_client" {}
variable "image_name_client" {}
variable "war_file_client" {}
#variable "mysql_port" {}
#variable "mysql_user" {}
#variable "mysql_password" {}
#variable "mysql_database" {}
variable "src_properties_file" {}
variable "dest_properties_file" {}
variable "info_server_port" {}
variable "info_client_workspace" {}
variable "info_server_workspace" {}
variable "src_properties_file_client" {} 
variable "dest_properties_file_client" {}
#variable "infodb_endpoint" {}
variable "mysql_creds" {}
variable "mysql_info" {}
variable "docker_image_id" {}
variable "ami_id_codedeploy_agent" {}

variable "codebucket" {}
variable "app_name" {}
variable "webapp_src_location" {}
variable "webapp_src_location_client" {}
variable "zip_file" {}
variable "zip_file_client" {}
variable "jar_file" {}
variable "jar_file_client" {}