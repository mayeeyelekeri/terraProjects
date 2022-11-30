project_name = "info"
aws_region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
open_cidr = "0.0.0.0/0"


public_subnets = { "subnet1" =  { cidr = "10.0.1.0/24", 
							 zone = "us-east-1a"
						   }, 
				   "subnet2" =  { cidr = "10.0.2.0/24", 
							 zone = "us-east-1b"
						   }
			     }



#......................................
# EC2 Related variables 
#......................................
ami_id = "ami-09d3b3274b6c5d4aa"
ami_id_ubuntu = "ami-08c40ec9ead489470"
docker_image_id = "ami-01f30e7b4edf0bc38"
ami_id_codedeploy_agent = "i-073cfa1a08e5c71f0"
instance_type = "t2.micro"
key_pair_path = "../../awsKeyPairDir"
key_file_name = "../../awsKeyPairDir/info.pem"
key_name = "info"

#......................................
#  Database properties 
#......................................
# All the information coming from TF_VAR variables
mysql_creds = "db_creds2"
mysql_info  = "mysql_info.yml.encrypted"

#......................................
#  Info-Server properties 	
#......................................
war_file = "/home/vagrant/SpringDataTest/target/SpringDataTest-0.0.1-SNAPSHOT.jar"
docker_file = "docker/Dockerfile"
image_name = "springdatatest:latest"
src_properties_file = "files/application-aws.properties.j2"
dest_properties_file = "/home/vagrant/SpringDataTest/src/main/resources/application-aws.properties"
info_server_port = "8080"
info_server_workspace = "/home/vagrant/SpringDataTest"
jar_file = "SpringDataTest-0.0.1-SNAPSHOT.jar"
webapp_src_location = "/home/vagrant/SpringDataTest/codedeploy"
zip_file = "info.zip"

#......................................
# Client properties  
#......................................
info_client_workspace = "/home/vagrant/Client"
src_properties_file_client = "files/application-aws.properties.client.j2"
dest_properties_file_client = "/home/vagrant/Client/src/main/resources/application.properties"
docker_file_client = "docker/Dockerfile_client"
image_name_client = "client:latest"
war_file_client = "Client-0.0.1-SNAPSHOT.jar"
jar_file_client = "Client-0.0.1-SNAPSHOT.jar"

codebucket = "codedeploy"
app_name = "info"
app_name_client = "client"
webapp_src_location_client = "/home/vagrant/Client/codedeploy"
zip_file_client = "client.zip"