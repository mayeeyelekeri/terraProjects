
# Import public key to aws 
resource "aws_key_pair" "mykeypair" {
    #provider    = var.aws_region
    key_name    = var.key-name
    public_key  = file(var.key-file-name-public)
}

/*# Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "webserver-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
} */ 

# Create EC2 web server in public subnet 
resource "aws_instance" "webserver" {
  count                       = 2
  ami                         = var.ami-id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.public-sg.id] # these values are exported from vpc-outputs.tf 
  subnet_id                   = aws_subnet.mysubnet["public"].id
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<html><body><h1><center> My public IP address is : </center></h1>' > index.html", 
      "echo '<h2  style=\"background-color:Tomato;\"><center>' >> index.html",
      "curl http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html",
      "echo '</h2></center> </body> </html>' >> index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.key-file-name-private)
      host        = self.public_ip
    }
  }
  tags = {
    Name = "${terraform.workspace}-webserver ${count.index}"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_key_pair.mykeypair]
} 

# Create EC2 server in Private subnet clear
resource "aws_instance" "dbserver" {
  ami                         = var.ami-id
  instance_type               = var.instance-type
  #associate_public_ip_address = no
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.private-sg.id] # these values are exported from vpc-outputs.tf 
  subnet_id                   = aws_subnet.mysubnet["private"].id
  
  tags = {
    Name = "${terraform.workspace}-dbserver-private"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_key_pair.mykeypair]
}
