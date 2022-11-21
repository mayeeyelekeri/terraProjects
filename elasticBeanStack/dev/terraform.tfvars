project-name = "elasticBeanStack"
aws_region = "us-east-1"
vpc-cidr = "10.0.0.0/16"
open-cidr = "0.0.0.0/0"
public-subnets = { "subnet1" =  { cidr = "10.0.1.0/24", 
							 zone = "us-east-1a"
						   }  
			   "subnet2" = { cidr = "10.0.2.0/24", 
							 zone = "us-east-1b" 
						   }
			 }

# ALB Related variables 
private-subnets = { "subnet1" =  { cidr = "10.0.4.0/24", 
							 zone = "us-east-1a"
						   },  
			   "subnet2" = { cidr = "10.0.5.0/24", 
							 zone = "us-east-1b" 
						   } 
			 }

	 
codebucket = "elasticbeanstack"
file-name = "springdemo-0.0.1-SNAPSHOT.war"
file-path = "ansible_templates/files"
app-name = "mywebapp"
webapp-src-location = "/home/vagrant/springdemo/target"