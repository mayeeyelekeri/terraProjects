aws_region = "us-east-1"
vpc-cidr = "192.168.0.0/16"
open-cidr = "0.0.0.0/0"
subnet-map = { "public" =  { cidr = "192.168.1.0/24", 
							 zone = "us-east-1a"
						   },  
			   "private" = { cidr = "192.168.2.0/24", 
							 zone = "us-east-1b" 
						   }
			 }
