
variable "vpc-cidr" { default = "10.0.0.0/16" } 

variable "subnet-map" {
	default = { "public" =  { cidr = "10.0.1.0/24", 
							 zone = "us-east-1a"
						   },  
			   "private" = { cidr = "10.0.2.0/24", 
							 zone = "us-east-1b" 
						   }
			 }
			 }


# Create VPC 
resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${terraform.workspace}-${var.vpc-cidr}"
    Environment = "${terraform.workspace}"
  }
}

# Create IGW and attach it to our VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = { 
    Name = "${terraform.workspace}-My IG"
    Environment = "${terraform.workspace}"
  }
}

# ---------------------------- PUBLIC --------------------------
# Create Public and Private Subnet 
resource "aws_subnet" "mysubnet" {
  for_each = var.subnet-map 
  vpc_id = aws_vpc.myvpc.id
  cidr_block = each.value.cidr
  availability_zone = each.value.zone
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${terraform.workspace}-${each.value.cidr} - ${each.value.zone}"
    Environment = "${terraform.workspace}"
  }
}

output "vpc-id" { value = aws_vpc.myvpc.id}