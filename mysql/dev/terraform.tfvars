project-name = "mysql"
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

