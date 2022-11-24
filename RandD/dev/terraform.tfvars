vpc-cidr = "192.168.0.0/16"

public-subnet-cidr-list = ["192.168.1.0/24" , "192.168.2.0/24"]
public-subnet-availability-zone-list = ["us-east-1a" , "us-east-1b"]

private-subnet-map = { "192.168.3.0/24" = "us-east-1a" 
					   "192.168.4.0/24" = "us-east-1b" }

private-subnet2-map = { "public1" = { cidr = "192.168.5.0/28", zone = "us-east-1a" },  
					    "public2" = { cidr = "192.168.6.0/28", zone = "us-east-1b" }, 
						"public3" = { cidr = "192.168.7.0/28", zone = "us-east-1c" },  
					    "public4" = { cidr = "192.168.8.0/28", zone = "us-east-1d" }
					  }

public-subnet-map2 =  { "public1" = { cidr = "192.168.11.0/28", zone = "us-east-1a" },  
					    "public2" = { cidr = "192.168.12.0/28", zone = "us-east-1b" }, 
						"public3" = { cidr = "192.168.13.0/28", zone = "us-east-1c" },  
					    "public4" = { cidr = "192.168.14.0/28", zone = "us-east-1d" }
					  }