resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${terraform.workspace} - myvpc - ${var.vpc-cidr}"
    Environment = "${terraform.workspace}"
  }
}

# Create Public Subnets from list  
resource "aws_subnet" "public-subnet" {
  count = length(var.public-subnet-cidr-list)   # get the number of items from the list 
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.public-subnet-cidr-list[count.index]    # get the iterator value 
  availability_zone = var.public-subnet-availability-zone-list[count.index]
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${terraform.workspace}-${var.public-subnet-cidr-list[count.index]} - ${var.public-subnet-availability-zone-list[count.index]}"
    Environment = "${terraform.workspace}"
  }
}

# Create Private Subnets from "Map"
resource "aws_subnet" "private-subnet" {
  for_each = var.private-subnet-map   # iterate for each item in map
  vpc_id = aws_vpc.myvpc.id
  cidr_block = each.key    # get the cidr block 
  availability_zone = each.value
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${terraform.workspace}-${each.key} - ${each.value}"
    Environment = "${terraform.workspace}"
  }
}

# Create Private2 Subnets from "Map of Map"
resource "aws_subnet" "private-subnet2" {
  for_each = var.private-subnet2-map   # iterate for each item in map
  vpc_id = aws_vpc.myvpc.id
  cidr_block = each.value.cidr    # get the cidr block 
  availability_zone = each.value.zone   # get the zone 
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${terraform.workspace}-${each.value.cidr} - ${each.value.zone}"
    Environment = "${terraform.workspace}"
  }
}
