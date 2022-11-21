# Create bean stack application 
resource "aws_elastic_beanstalk_application" "mywebapp" {
  name        = "mywebapp"
  description = "mywebapp"
}

/*
# Create environment 
resource "aws_elastic_beanstalk_environment" "webapp-env" {
  name                = "webapp-env"
  application         = aws_elastic_beanstalk_application.mywebapp.name
  solution_stack_name = "64bit Amazon Linux 2015.03 v2.0.3 running Go 1.4"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "vpc-xxxxxxxx"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "subnet-xxxxxxxx"
  }
}
*/



# Create s3 bucket 
resource "aws_s3_bucket" "codebucket" {
  bucket = "${var.codebucket}-${random_integer.suffix.result}"
  
  tags = {
    Name        = var.codebucket
    Environment = "dev"
  }
}

# Enable versioning for bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.codebucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#.................................................
resource "random_integer" "suffix" {
  min = 100
  max = 999
}

#.................................................
# upload war file to S3 object 
resource "null_resource" "upload_file" { 

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost \
    bucket=${aws_s3_bucket.codebucket.id} \
    file_name=${var.file-name} \
    webapp_src_location=${var.webapp-src-location}" \
  ansible_templates/aws_cmd_execution.yaml
EOF
  } # End of provisioner

  depends_on = [aws_s3_bucket.codebucket]
} # end of "null_resource" "upload_file"