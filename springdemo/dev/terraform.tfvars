# project_name = "springdemo"
aws_region = "us-east-1"

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

git_creds   = "git_creds"
state_bucket = "terraprojects5"

#......................................
# EC2 Related variables 
#......................................
ami_id = "ami-09d3b3274b6c5d4aa"
instance_type = "t2.micro"
key_name = "springdemo"
app_name_server = "springdemo"
instance_profile_name =  "myinstanceprofile"
autoscale_min = 2
autoscale_max = 3
app_health_check_path = "/"
template_name_server = "docker_and_codedeploy_agent_server"

#......................................
#  Info-Server properties 	
#......................................
zip_file_server = "springdemo.zip"

codebucket_name = "codedeploy"

#......................................
# codebuild properties  
#......................................
server_project_name = "springdemo"
server_project_description = "server project" 
source_provider = "github"
buildbucket_name = "codebuild"

repo_name  = "springdemo"
repo_owner = "mayeeyelekeri"
branch     = "main"