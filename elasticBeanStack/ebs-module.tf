# Create bean stack application 
resource "aws_elastic_beanstalk_application" "mywebapp" {
  name        = "mywebapp"
  description = "mywebapp"

  depends_on = [null_resource.upload_file]
}

resource "aws_elastic_beanstalk_application_version" "beanstalk_myapp_version" {
  application = aws_elastic_beanstalk_application.mywebapp.name
  bucket = aws_s3_bucket.codebucket.id
  key = ${var.file-name}
  name = "${var.app-name}-1.0.0"

  depends_on = [aws_elastic_beanstalk_application.mywebapp]
}


# Create environment 
resource "aws_elastic_beanstalk_environment" "myapp-env" {
  name = "mywebapp-env"
  application = aws_elastic_beanstalk_application.mywebapp.name
  solution_stack_name = "64bit Amazon Linux 2 v3.1.7 running Corretto 11"
  version_label = aws_elastic_beanstalk_application_version.beanstalk_myapp_version.name
 
  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t2.micro"
  }

  setting {
   namespace = "aws:autoscaling:launchconfiguration"
   name = "IamInstanceProfile"
   value = "aws-elasticbeanstalk-ec2-role"
  }

}



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