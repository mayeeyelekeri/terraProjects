# Create and Elastic IP Address for NAT Gateway use
resource "aws_eip" "eip" {
  domain = "vpc"
}

# Create NAT Gateway in public subnet 
resource "aws_nat_gateway" "nat_gateway" {
  # get the first public subnet ID 
  subnet_id     = values(aws_subnet.public)[0].id 
  allocation_id = aws_eip.eip.id

  tags = {
    Name = "${terraform.workspace}-My public NAT Gateway"
    Environment = "${terraform.workspace}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Create private route table and attach NAT Gateway to it
resource "aws_default_route_table" "private_route" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id  
  route {
    cidr_block = var.open_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${terraform.workspace}-Terraform-Private-RouteTable"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_nat_gateway.nat_gateway, aws_subnet.private]
} 

# Associate private subnets to route table 
resource "aws_route_table_association" "private_route_table_association" {
  for_each       = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_default_route_table.private_route.id

  depends_on = [aws_subnet.private,  aws_default_route_table.private_route]
} 
