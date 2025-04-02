aws_region = "us-east-1"
vpc-cidr = "10.0.0.0/25"
open-cidr = "0.0.0.0/0"
subnet-map = { "public" =  { cidr = "10.0.0.0/28", 
							 zone = "us-east-1a"
						   },  
			   "private" = { cidr = "10.0.0.96/27", 
							 zone = "us-east-1b" 
						   }
			 }

# EC2 Related variables 
ami-id = "ami-09d3b3274b6c5d4aa"
instance-type = "t2.micro"
key-file-name-public = "~/.ssh/id_rsa.pub"
key-file-name-private = "~/.ssh/id_rsa"
key-name = "ec2PublicPrivate"
