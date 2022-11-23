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

# EC2 Related variables 
ami_id = "ami-09d3b3274b6c5d4aa"
ami_id_ubuntu = "ami-08c40ec9ead489470"
myimage = "ami-09d3b3274b6c5d4aa"
instance_type = "t2.micro"
key_pair_path = "../../awsKeyPairDir"
key_file_name = "../../awsKeyPairDir/springBoot.pem"
key_name = "springBoot"

# ALB Related variables 
private_subnets = { "subnet1" =  { cidr = "10.0.4.0/24", 
							 zone = "us-east-1a"
						   }
				  }

ec2_data = {   "subnet1" = { color = "Red"},
			   "subnet2" = { color = "Blue"} }
	
war_file = "/home/vagrant/SpringDataTest/target/SpringDataTest-0.0.1-SNAPSHOT.jar"
docker_file = "docker/Dockerfile"
image_name = "springdatatest:latest"

war_file_client = "/home/vagrant/Client/target/Client-0.0.1-SNAPSHOT.jar"
docker_file_client = "docker/Dockerfile_client"
image_name_client = "client:latest"

db_name = "infodb"
mysql_database ="infodb"
mysql_port = "3306"
mysql_user = "admin"
mysql_password = "admin123"
mysql_host = ""
src_properties_file = "application-aws.properties.j2"
dest_properties_file = "/home/vagrant/SpringDataTest/src/main/resources/application-aws.properties"
info-server-port = "8080"
info_client_workspace = "/home/vagrant/Client"
info_server_workspace = "/home/vagrant/SpringDataTest"
dbdump_file = "/home/vagrant/infodb/mysqldump_april282020.txt"
