project-name = "info"
aws_region = "us-east-1"
vpc-cidr = "10.0.0.0/16"
open-cidr = "0.0.0.0/0"
public-subnets = { "subnet1" =  { cidr = "10.0.1.0/24", 
							 zone = "us-east-1a"
						   }, 
				   "subnet2" =  { cidr = "10.0.2.0/24", 
							 zone = "us-east-1b"
						   }
			     }

# EC2 Related variables 
ami-id = "ami-09d3b3274b6c5d4aa"
ami-id-ubuntu = "ami-08c40ec9ead489470"
myimage = "ami-09d3b3274b6c5d4aa"
instance-type = "t2.micro"
key-pair-path = "../../awsKeyPairDir"
key-file-name = "../../awsKeyPairDir/springBoot.pem"
key-name = "springBoot"

# ALB Related variables 
private-subnets = { "subnet1" =  { cidr = "10.0.4.0/24", 
							 zone = "us-east-1a"
						   }
				  }

ec2-data = {   "subnet1" = { color = "Red"},
			   "subnet2" = { color = "Blue"} }
	
war-file = "/home/vagrant/SpringDataTest/target/SpringDataTest-0.0.1-SNAPSHOT.jar"
docker-file = "docker/Dockerfile"
image-name = "springdatatest:latest"

war-file-client = "/home/vagrant/Client/target/Client-0.0.1-SNAPSHOT.jar"
docker-file-client = "docker/Dockerfile_client"
image-name-client = "client:latest"

db-name = "infodb"
mysql-database ="infodb"
mysql-port = "3306"
mysql-user = "admin"
mysql-password = "admin123"
mysql-host = ""
src_properties_file = "application-aws.properties.j2"
dest_properties_file = "/home/vagrant/SpringDataTest/src/main/resources/application-aws.properties"
