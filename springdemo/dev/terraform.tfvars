
aws_region = "us-east-1"
state_bucket = "terraprojects"

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
# project_name = "springdemo2"  
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

#......................................
#  CodeDeploy properties 	
#......................................
zip_file = "springdemo2.zip"

#......................................
#  ElasticBeanStalk properties 	
#......................................
stack_name = "64bit Amazon Linux 2 v3.4.7 running Corretto 17"
file_name = "springdemo2-1.0.0-SNAPSHOT.jar"