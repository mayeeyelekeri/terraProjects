# -------------------- Public Security Groups --------------
# Create SG for allowing TCP/80 & TCP/22
resource "aws_security_group" "public_sg" {
  name        = "${terraform.workspace}-public-sg"
  description = "Allow TCP/80 & TCP/22"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.open_cidr]
  }
  ingress {
    description = "allow traffic from TCP/80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.open_cidr]
  }
  ingress {
    description = "allow traffic from TCP/8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.open_cidr]
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

  depends_on = [aws_vpc.vpc , aws_route_table.internet_route, aws_subnet.public ]
}

# Private Security Group
resource "aws_security_group" "private-sg" {
  name        = "${terraform.workspace}-private-sg"
  description = "Allow all access from public subnet"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow http from public subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = values(aws_subnet.public)[*].cidr_block
  }  /*
  ingress {
    description = "Allow http from public subnet"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [values(aws_subnet.public)[*].cidr_block]
  } 
  ingress {
    description = "Allow ssh from  public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [values(aws_subnet.public)[*].cidr_block]
  } 
  ingress {
    description = "Allow ping  from public subnet"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [values(aws_subnet.public)[*].cidr_block]
  } */ 
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

  depends_on = [aws_vpc.vpc , aws_route_table.internet_route, aws_subnet.private]
}  
