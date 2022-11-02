project-name = "applicationLB"
aws_region = "us-east-1"
vpc-cidr = "10.0.0.0/16"
open-cidr = "0.0.0.0/0"
subnet-map = { "subnet1" =  { cidr = "10.0.1.0/24", 
							 zone = "us-east-1a"
						   },  
			   "subnet2" = { cidr = "10.0.2.0/24", 
							 zone = "us-east-1b" 
						   }, 
			   "subnet3" = { cidr = "10.0.3.0/24", 
							 zone = "us-east-1c" 
						   }
			 }

# EC2 Related variables 
ami-id = "ami-09d3b3274b6c5d4aa"
instance-type = "t2.micro"
key-pair-path = "../../awsKeyPairDir"
key-file-name = "../../awsKeyPairDir/applicationLB.pem"
key-name = "applicationLB"

# ALB Related variables 
