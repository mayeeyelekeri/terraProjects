# Import public key to aws 
resource "aws_key_pair" "mykeypair" {
    key_name    = var.key-name
    public_key  = file("~/.ssh/id_rsa.pub")
}

# Get Linux AMI ID 
data "aws_ssm_parameter" "linux-ami" {
    #provider    = "aws" 
    name        = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create a policy for S3 access for EC2 
resource "aws_iam_policy" "mys3policy" {
  name        = "S3AccessPolicy"
  path        = "/"
  description = "My S3 access policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action": [
                "s3:Get*",
                "s3:List*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
}

# Create a role for EC2 
resource "aws_iam_role" "myec2role" {
    name = "myec2role"
    assume_role_policy = jsonencode({
     "Version": "2012-10-17",
     "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "ec2.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
     }
     ]
    })
}

# Create a instance profile 
resource "aws_iam_instance_profile" "myinstanceprofile" {
  name = "myinstanceprofile"
  role = aws_iam_role.myec2role.name
  path = "/"
} # end of resource aws_iam_role

# Attach policy to role 
resource "aws_iam_role_policy_attachment" "roll_attach_to_policy" {
  role       = aws_iam_role.myec2role.name
  policy_arn = aws_iam_policy.mys3policy.arn
}

# Create EC2 web servers in different subnets 
resource "aws_instance" "http-server" {
  for_each                    = aws_subnet.public-subnets
  ami                         = var.ami-id
  instance_type               = var.instance-type
  iam_instance_profile        = aws_iam_instance_profile.myinstanceprofile.name
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.public-sg.id] 
  subnet_id                   = each.value.id
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.id} && ansible-playbook --extra-vars 'passed_in_hosts=${self.public_ip}' ansible_templates/install_codedeploy_agent.yaml
EOF
  } # End of provisioner

  tags = {
    Name = join("-", ["${terraform.workspace}", "httpserver" ])
    Environment = "${terraform.workspace}"
  }
}   

