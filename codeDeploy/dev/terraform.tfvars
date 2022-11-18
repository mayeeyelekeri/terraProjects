project-name = "applicationLBPrivatePublic"
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

# EC2 Related variables 
ami-id = "ami-09d3b3274b6c5d4aa"
ami-id-ubuntu = "ami-08c40ec9ead489470"
myimage = "ami-09d3b3274b6c5d4aa"
instance-type = "t2.micro"
key-pair-path = "../../awsKeyPairDir"
key-file-name = "../../awsKeyPairDir/codeDeploy.pem"
key-name = "codeDeploy"

# ALB Related variables 
private-subnets = { "subnet1" =  { cidr = "10.0.4.0/24", 
							 zone = "us-east-1a"
						   },  
			   "subnet2" = { cidr = "10.0.5.0/24", 
							 zone = "us-east-1b" 
						   } 
			 }

ec2-data = {   "subnet1" = { color = "Red"},  
			   "subnet2" = { color = "Green"}, 
			   "subnet3" = { color = "Blue"}
			 }

			 
codebucket = "codedeploy"
zip-file = "webapp.zip"
zip-path = "ansible_templates/files"
app-name = "webapp"