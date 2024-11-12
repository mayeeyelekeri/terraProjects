/* --------- Create VPC ----------------------------------
 Inputs: 
 1) VPC CIDR  
 Outputs: 
 1) VPC ID 
----------------------------------------------------------- */ 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${terraform.workspace}-${var.vpc_cidr}"
    Environment = "${terraform.workspace}"
  }
}

# 
/* --------- Create IGW and attach it to our VPC ----------
 Inputs: 
 1) VPC ID
----------------------------------------------------------- */ 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = { 
    Name = "${terraform.workspace}-My IG"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_vpc.vpc]
}

# ---------------------------- PUBLIC --------------------------
/* --------- Create Public Subnets -------------------------
 Inputs: 
 1) VPC ID
 2) Public Subnet map 
 3) List of availbility zones 
 Outputs: 
 1) public subnets  
----------------------------------------------------------- */ 
resource "aws_subnet" "public" {
  for_each = var.public_subnet_map
  vpc_id = aws_vpc.vpc.id
  cidr_block = each.value.cidr
  availability_zone = each.value.zone
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${terraform.workspace}-${each.value.cidr} - ${each.value.zone}"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_vpc.vpc]
}
 
/* --------- Create route table and attach IG to it --------
 Inputs: 
 1) VPC ID
 2) cidr infomation to provide access 
 3) Internet gateway (for internet route)
 Outputs: 
 1) Route table ID   
----------------------------------------------------------- */ 
resource "aws_route_table" "internet_route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.open_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${terraform.workspace}-Terraform-Public-RouteTable"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# 
/* ----- Associate ALL public subnets to route table ------
 Inputs: 
 1) Public subnets 
 2) cidr infomation to provide access 
 3) Route table ID 
----------------------------------------------------------- */ 
resource "aws_route_table_association" "public_route_table_association1" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.internet_route.id

  depends_on = [aws_route_table.internet_route, aws_subnet.public ]
}