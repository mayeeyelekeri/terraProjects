#Create VPC 
resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${terraform.workspace}-applicationLB-vpc"
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
# Create 3 subnets 
resource "aws_subnet" "public-subnet1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.public-subnet1-cidr
  availability_zone = var.availability-zone-1
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${terraform.workspace}-${var.public-subnet1-name} - ${var.public-subnet1-cidr}"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.public-subnet2-cidr
  availability_zone = var.availability-zone-2
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${terraform.workspace}-${var.public-subnet2-name} - ${var.public-subnet2-cidr}"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_subnet" "public-subnet3" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.public-subnet3-cidr
  availability_zone = var.availability-zone-3
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${terraform.workspace}-${var.public-subnet3-name} - ${var.public-subnet3-cidr}"
    Environment = "${terraform.workspace}"
  }
}

# Create route table and attach IG to it
resource "aws_route_table" "internet-route" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = var.open-cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${terraform.workspace}-Terraform-Public-RouteTable"
    Environment = "${terraform.workspace}"
  }
}

# Associate public subnet to route table 
resource "aws_route_table_association" "public-route-table-association1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.internet-route.id
}

resource "aws_route_table_association" "public-route-table-association2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.internet-route.id
}

resource "aws_route_table_association" "public-route-table-association3" {
  subnet_id      = aws_subnet.public-subnet3.id
  route_table_id = aws_route_table.internet-route.id
}


# Create SG for allowing TCP/80 & TCP/22
resource "aws_security_group" "public-sg" {
  name        = "${terraform.workspace}-public-sg"
  description = "Allow TCP/80 & TCP/22"
  vpc_id      = aws_vpc.myvpc.id
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.open-cidr]
  }
  ingress {
    description = "allow traffic from TCP/80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.open-cidr]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${terraform.workspace}-Public-Sec-Group"
    Environment = "${terraform.workspace}"
  }
}
