# project_name = "info"
aws_region = "us-east-1"

#......................................
# VPC Related variables 
#......................................
vpc_cidr = "10.0.0.0/24"
open_cidr = "0.0.0.0/0"
public_subnet_map = { "subnet1" =  { cidr = "10.0.0.0/28", 
							 zone = "us-east-1a"
						   }, 
				   "subnet2" =  { cidr = "10.0.0.16/28", 
							 zone = "us-east-1b"
						   }
			     } # end of subnet_map 

private_subnet_map = { 
				   "subnet3" =  { cidr = "10.0.0.32/28", 
							 zone = "us-east-1a"
						   }
				   "subnet4" =  { cidr = "10.0.0.48/28", 
							 zone = "us-east-1b"
						   }
			     } # end of subnet_map private 

#......................................
# EC2 Related variables 
#......................................
ami_id = "ami-09d3b3274b6c5d4aa"
instance_type = "t2.micro"
key_name = "info"
app_name_server = "info"
app_name_client = "client"
instance_profile_name =  "myinstanceprofile"
autoscale_min = 2
autoscale_max = 3
app_health_check_path = "/infos"

#......................................
#  Database properties 
#......................................
# All the information coming from AWS Secrets variables
mysql_creds = "db_creds1"

#......................................
#  Info-Server properties 	
#......................................
war_file_server = "/home/vagrant/SpringDataTest/target/SpringDataTest-0.0.1-SNAPSHOT.jar"
docker_file_server = "docker/Dockerfile"
src_properties_file_server = "files/application-aws.properties.j2"
dest_properties_file_server = "/home/vagrant/SpringDataTest/src/main/resources/application-aws.properties"
info_server_workspace = "/home/vagrant/SpringDataTest"
jar_file_server = "SpringDataTest-0.0.1-SNAPSHOT.jar"
webapp_src_location_server = "/home/vagrant/SpringDataTest/codedeploy"
zip_file_server = "info.zip"

#......................................
# Client properties  
#......................................
info_client_workspace = "/home/vagrant/Client"
src_properties_file_client = "files/application-aws.properties.client.j2"
dest_properties_file_client = "/home/vagrant/Client/src/main/resources/application.properties"
docker_file_client = "docker/Dockerfile_client"
war_file_client = "Client-0.0.1-SNAPSHOT.jar"
jar_file_client = "Client-0.0.1-SNAPSHOT.jar"
info_client_port = "8080"

codebucket_name = "codedeploy"

webapp_src_location_client = "/home/vagrant/Client/codedeploy"
zip_file_client = "client.zip"