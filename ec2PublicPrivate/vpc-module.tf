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
resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.mysubnet["public"].id
  route_table_id = aws_route_table.internet-route.id
}

# Create and Elastic IP Address fot NAT Gateway use
resource "aws_eip" "my-eip" {
  vpc = true
}

# Create NAT Gateway in public subnet 
resource "aws_nat_gateway" "nat-gateway" {
  subnet_id     = aws_subnet.mysubnet["public"].id
  allocation_id = aws_eip.my-eip.id
  tags = {
    Name = "${terraform.workspace}-My public NAT Gateway"
    Environment = "${terraform.workspace}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# ---------------------------- PRIVATE --------------------------
# Create private route table and attach NAT Gateway to it
resource "aws_default_route_table" "private-route" {
  default_route_table_id = aws_vpc.myvpc.default_route_table_id  
  route {
    cidr_block = var.open-cidr
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    Name = "${terraform.workspace}-Terraform-Private-RouteTable"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_nat_gateway.nat-gateway]
} 

# Associate private subnet to route table 
resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.mysubnet["private"].id
  route_table_id = aws_default_route_table.private-route.id

  depends_on = [aws_subnet.mysubnet,  aws_default_route_table.private-route]
}

# -------------------- Security Groups --------------
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

# Private Security Group
resource "aws_security_group" "private-sg" {
  name        = "${terraform.workspace}-private-sg"
  description = "Allow all access from public subnet"
  vpc_id      = aws_vpc.myvpc.id
  ingress {
    description = "Allow http from public subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.mysubnet["public"].cidr_block]
  } 
  ingress {
    description = "Allow ssh from  public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.mysubnet["public"].cidr_block]
  } 
  ingress {
    description = "Allow ping  from public subnet"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_subnet.mysubnet["public"].cidr_block]
  } 
  # ------- By default terraform doesn't create this block ----- 
  # ------- I spent lot of time to investigate this ------------
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${terraform.workspace}-Private-Security-Group"
    Environment = "${terraform.workspace}"
  }
} 
