#Create VPC 
resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${terraform.workspace}-terraform-vpc"
  }
}

# Create IGW and attach it to our VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = { 
    Name = "${terraform.workspace}-My IG"
  }
}

# ---------------------------- PUBLIC --------------------------
# Create Public Subnet 
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.public-subnet-cidr
  availability_zone = var.availability-zone-a
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${terraform.workspace}-${var.public-subnet-name}"
  }
}

# Create route table and attach IG to it
resource "aws_route_table" "internet-route" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${terraform.workspace}-Terraform-Public-RouteTable"
  }
}

# Associate public subnet to route table 
resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.internet-route.id
}

# ---------------------------- PRIVATE --------------------------
# Create Private Subnet 
resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.private-subnet-cidr
  availability_zone = var.availability-zone-b
  map_public_ip_on_launch = "false"

  tags = {
    Name = var.private-subnet-name
  }
}

# Create and Elastic IP Address fot NAT Gateway use
resource "aws_eip" "my-eip" {
  vpc = true
}

# Create NAT Gateway in public subnet 
resource "aws_nat_gateway" "nat-gateway" {
  subnet_id     = aws_subnet.public-subnet.id
  allocation_id = aws_eip.my-eip.id
  tags = {
    Name = "${terraform.workspace}-My public NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Create private route table and attach NAT Gateway to it
resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = var.public-subnet-cidr
    gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    Name = "${terraform.workspace}-Terraform-Private-RouteTable"
  }
}

# Associate private subnet to route table 
resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route.id
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow traffic from TCP/80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Private Security Group
resource "aws_security_group" "private-sg" {
  name        = "${terraform.workspace}-private-sg"
  description = "Allow all access from public subnet"
  vpc_id      = aws_vpc.myvpc.id
  ingress {
    description = "Allow from public subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.public-subnet-cidr}"]
  }  
}
