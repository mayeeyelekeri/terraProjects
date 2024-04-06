# Create bean stack application 
resource "aws_elastic_beanstalk_application" "mywebapp" {
  name        = "${var.app_name}"
  description = "${var.app_name}"

#  depends_on = [aws_iam_role_policy.ebs_policy]
}

resource "aws_elastic_beanstalk_application_version" "beanstalk_myapp_version" {
  application = "${var.app_name}"
  bucket = "${var.bucket_name}"
  key = "${var.app_name}/${var.file_name}"
  name = "${var.app_name}-1.0.0"

  depends_on = [aws_elastic_beanstalk_application.mywebapp]
}


# Create environment 
resource "aws_elastic_beanstalk_environment" "myapp-env" {
  name = "mywebapp-env2"
  application = aws_elastic_beanstalk_application.mywebapp.name
  solution_stack_name = var.stack_name
  version_label = aws_elastic_beanstalk_application_version.beanstalk_myapp_version.name

  // set VPC  
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  // set subnet 
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${var.public_subnet1} , ${var.public_subnet2}"
  }

  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t2.micro"
  }

  setting {
   namespace = "aws:autoscaling:launchconfiguration"
   name = "IamInstanceProfile"
   value = var.instance_profile_name
   #value = "aws-elasticbeanstalk-ec2-role"  # **** this gets created automatically from aws console when an app is created 
  }

  setting {
    name = "SERVER_PORT"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "5000"
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = var.security_group
  }

  depends_on = [aws_elastic_beanstalk_application.mywebapp]
}
