# project_name = "springdemo"
aws_region = "us-east-1"
state_bucket = "terraprojects2"

#......................................
# VPC Related variables 
#......................................
vpc_cidr = "10.0.0.0/24"  # 256 IP addresses 
open_cidr = "0.0.0.0/0"
public_subnet_map = { "subnet1" =  { cidr = "10.0.0.0/26", 
							 zone = "us-east-1a"
						   }, 
				   "subnet2" =  { cidr = "10.0.0.64/26", 
							 zone = "us-east-1b"
						   }
			     } # end of subnet_map 

private_subnet_map = { 
				   "subnet3" =  { cidr = "10.0.0.128/26", 
							 zone = "us-east-1a"
						   }
				   "subnet4" =  { cidr = "10.0.0.192/26", 
							 zone = "us-east-1b"
						   }
			     } # end of subnet_map private 

#......................................
# codebuild properties  
#......................................
project_name = "springdemo2"
project_description = "springdemo2 project" 
source_provider = "github"
buildbucket_name = "codebuild"  
git_creds   = "git_creds"

#......................................
# ALB properties  
#......................................
application_port = "8080"
app_health_check_path = "/"

 
#......................................
# Autoscaling variables 
#......................................
ami_id = "ami-09d3b3274b6c5d4aa"
instance_type = "t2.micro"
key_name = "info"
app_name = "springdemo2"
instance_profile_name =  "myinstanceprofile"
autoscale_min = 1
autoscale_max = 1
autoscale_desired = 1
template_name = "docker_and_codedeploy_agent"

/* 
#......................................
#  Database properties 
#......................................
# All the information coming from AWS Secrets variables

#......................................
#  Info-Server properties 	
#......................................
# war_file = "/home/vagrant/SpringDataTest/target/SpringDataTest-0.0.1-SNAPSHOT.jar"
docker_file = "docker/Dockerfile"
src_properties_file = "files/application-aws.properties.j2"
dest_properties_file = "/home/vagrant/SpringDataTest/src/main/resources/application-aws.properties"
app_workspace = "/home/vagrant/SpringDataTest"
jar_file = "SpringDataTest-0.0.1-SNAPSHOT.jar"
# webapp_src_location_server = "/home/vagrant/SpringDataTest/codedeploy"
zip_file = "springdemo.zip"

war_file = "springdemo-0.0.1-SNAPSHOT.jar"

codebucket_name = "codedeploy"
*/
