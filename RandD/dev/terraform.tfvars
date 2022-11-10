vpc-cidr = "10.0.0.0/16"

public-subnet-cidr-list = ["10.0.1.0/24" , "10.0.2.0/24"]
public-subnet-availability-zone-list = ["us-east-1a" , "us-east-1b"]

private-subnet-map = { "10.0.3.0/24" = "us-east-1a" 
					   "10.0.4.0/24" = "us-east-1b" }

private-subnet2-map = { "public1" = { cidr = "10.0.5.0/28", zone = "us-east-1a" },  
					    "public2" = { cidr = "10.0.6.0/28", zone = "us-east-1b" }, 
						"public3" = { cidr = "10.0.7.0/28", zone = "us-east-1c" },  
					    "public4" = { cidr = "10.0.8.0/28", zone = "us-east-1d" }
					  }

public-subnet-map2 =  { "public1" = { cidr = "10.0.11.0/28", zone = "us-east-1a" },  
					    "public2" = { cidr = "10.0.12.0/28", zone = "us-east-1b" }, 
						"public3" = { cidr = "10.0.13.0/28", zone = "us-east-1c" },  
					    "public4" = { cidr = "10.0.14.0/28", zone = "us-east-1d" }
					  }