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
/* resource "aws_subnet" "mysubnet" {
  for_each = var.subnet-map 
  vpc_id = aws_vpc.myvpc.id
  cidr_block = each.value.cidr
  availability_zone = each.value.zone
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${terraform.workspace}-${each.value.cidr} - ${each.value.zone}"
    Environment = "${terraform.workspace}"
  }
} */ 

resource "aws_subnet" "mysubnet1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.subnet-map["subnet1"].cidr
  availability_zone = var.subnet-map["subnet1"].zone
  map_public_ip_on_launch = "true"

  tags = {
    Name = join ("-" , ["${terraform.workspace}", "${var.subnet-map["subnet3"].cidr}", "${var.subnet-map["subnet3"].zone}"])
    Environment = "${terraform.workspace}"
  }
}

resource "aws_subnet" "mysubnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.subnet-map["subnet2"].cidr
  availability_zone = var.subnet-map["subnet2"].zone
  map_public_ip_on_launch = "true"

  tags = {
    Name = join ("-" , ["${terraform.workspace}", "${var.subnet-map["subnet3"].cidr}", "${var.subnet-map["subnet3"].zone}"])
    Environment = "${terraform.workspace}"
  }
}

resource "aws_subnet" "mysubnet3" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.subnet-map["subnet3"].cidr
  availability_zone = var.subnet-map["subnet3"].zone
  map_public_ip_on_launch = "true"

  tags = {
    Name = join ("-" , ["${terraform.workspace}", "${var.subnet-map["subnet3"].cidr}", "${var.subnet-map["subnet3"].zone}"])
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

# Associate ALL public subnets to route table 
resource "aws_route_table_association" "public-route-table-association1" {
  subnet_id      = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.internet-route.id
}

resource "aws_route_table_association" "public-route-table-association2" {
  subnet_id      = aws_subnet.mysubnet2.id
  route_table_id = aws_route_table.internet-route.id
}

resource "aws_route_table_association" "public-route-table-association3" {
  subnet_id      = aws_subnet.mysubnet3.id
  route_table_id = aws_route_table.internet-route.id
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
