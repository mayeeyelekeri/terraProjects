# Create bean stack docker application 
resource "aws_elastic_beanstalk_application" "dockerapp" {
  name        = "${var.dockerapp-name}"
  description = "${var.dockerapp-name}"

  depends_on = [null_resource.upload_file, aws_iam_role_policy.ebs_policy]
}

resource "aws_elastic_beanstalk_application_version" "beanstalk_dockerapp_version" {
  application = aws_elastic_beanstalk_application.dockerapp.name
  bucket = aws_s3_bucket.codebucket.id
  key = var.dockerfile-name
  name = "${var.dockerapp-name}-1.0.0"

  depends_on = [aws_elastic_beanstalk_application.dockerapp]
}


# Create environment 
resource "aws_elastic_beanstalk_environment" "dockerapp-env" {
  name = "dockerapp-env"
  application = aws_elastic_beanstalk_application.dockerapp.name
  solution_stack_name = var.dockerstack-name
  version_label = aws_elastic_beanstalk_application_version.beanstalk_dockerapp_version.name
 
  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t2.micro"
  }

  setting {
   namespace = "aws:autoscaling:launchconfiguration"
   name = "IamInstanceProfile"
   value = var.instance-profile
   #value = "aws-elasticbeanstalk-ec2-role"  # **** this gets created automatically from aws console when an app is created 
  }

  setting {
    name = "SERVER_PORT"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "5000"
  }

  depends_on = [aws_iam_role.beanstackrole, aws_iam_instance_profile.myinstanceprofile]
}

#.................................................
# upload war file to S3 object 
resource "null_resource" "upload_dockerfile" { 

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
aws s3 cp "${var.dockerwebapp-src-location}/${var.dockerfile-name}" s3://"${aws_s3_bucket.codebucket.id}"
EOF
  } # End of provisioner

  depends_on = [aws_s3_bucket.codebucket]
} # end of "null_resource" "upload_file"
