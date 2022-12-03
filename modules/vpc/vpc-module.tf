# Create VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${terraform.workspace}-${var.vpc_cidr}"
    Environment = "${terraform.workspace}"
  }
}

# Create IGW and attach it to our VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = { 
    Name = "${terraform.workspace}-My IG"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_vpc.vpc]
}

# ---------------------------- PUBLIC --------------------------
# Create Public Subnets 
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

# Create route table and attach IG to it
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

# Associate ALL public subnets to route table 
resource "aws_route_table_association" "public_route_table_association1" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.internet_route.id

  depends_on = [aws_route_table.internet_route, aws_subnet.public ]
}

# ---------------------------- PRIVATE --------------------------
# Create Public Subnets 
resource "aws_subnet" "private" {
  for_each = var.private_subnet_map
  vpc_id = aws_vpc.vpc.id
  cidr_block = each.value.cidr
  availability_zone = each.value.zone
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${terraform.workspace}-${each.value.cidr} - ${each.value.zone} - private"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_vpc.vpc]
}