aws_region = "us-east-1"
vpc-cidr = "192.168.0.0/16"
open-cidr = "0.0.0.0/0"
subnet-map = { "subnet1" =  { cidr = "192.168.1.0/24", 
							 zone = "us-east-1a"
						   },  
			   "subnet2" = { cidr = "192.168.2.0/24", 
							 zone = "us-east-1b" 
						   }, 
			   "subnet3" = { cidr = "192.168.3.0/24", 
							 zone = "us-east-1c" 
						   }
			 }

# EC2 Related variables 
ami-id = "ami-09d3b3274b6c5d4aa"
instance-type = "t2.micro"
project-name = "ec2PublicPrivate"

#key-pair-path = "../../.ssh"
key-file-name = "../../.ssh/id_rsa"
key-name = "keyfile"