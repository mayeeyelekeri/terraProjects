aws_region = "us-east-1"
state_bucket = "terraprojects1"

#......................................
# VPC Related variables 
#......................................
vpc_cidr = "192.168.1.0/24"  # 256 IP addresses 
open_cidr = "0.0.0.0/0"
public_subnet_map = { "subnet1" =  { cidr = "192.168.1.0/26", 
							 zone = "us-east-1a"
						   }, 
				   "subnet2" =  { cidr = "192.168.1.64/26", 
							 zone = "us-east-1b"
						   }
			     } # end of subnet_map 

private_subnet_map = { 
				   "subnet3" =  { cidr = "192.168.1.128/26", 
							 zone = "us-east-1a"
						   }
				   "subnet4" =  { cidr = "192.168.1.192/26", 
							 zone = "us-east-1b"
						   }
			     } # end of subnet_map private 


# Lambda related 
function_name = "myfunction"
