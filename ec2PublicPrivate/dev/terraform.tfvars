aws_region = "us-east-1"
vpc-cidr = "10.0.0.0/16"
open-cidr = "0.0.0.0/0"
subnet-map-public = { "public" =  { cidr = "10.0.1.0/24", 
							 zone = "us-east-1a"
					}

subnet-map-private = { cidr = "10.0.2.0/24", 
							 zone = "us-east-1b" 
			   	     }
			 

# EC2 Related variables 
ami-id = "ami-09d3b3274b6c5d4aa"
instance-type = "t2.micro"
key-file-name-public = "~/.ssh/id_rsa.pub"
key-file-name-private = "~/.ssh/id_rsa"
key-name = "ec2PublicPrivate"
