# Create bean stack application 
resource "aws_elastic_beanstalk_application" "mywebapp" {
  name        = "${var.app_name}"
  description = "${var.app_name}"

#  depends_on = [aws_iam_role_policy.ebs_policy]
}

# Create application version  
resource "aws_elastic_beanstalk_application_version" "beanstalk_myapp_version" {
  application = "${var.app_name}"
  bucket = "${var.bucket_name}"
  key = "${var.app_name}/${var.file_name}"
  name = "${var.app_name}-${var.app_version}"

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

  // set subnets, subnet names should be a command separated string  
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${var.public_subnet1} , ${var.public_subnet2}"  
  }

  // set instance type 
  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t2.micro"
  }

  // set launch configuration 
  setting {
   namespace = "aws:autoscaling:launchconfiguration"
   name = "IamInstanceProfile"
   #value = var.instance_profile_name
   value = aws_iam_instance_profile.beanstalk_profile.name  
   #value = "AWSServiceRoleForElasticBeanstalk"  **** this gets created automatically from aws console when an app is created 
  }

  // set port (5000 is the proxy port, its better to overide it )
  setting {
    name = "SERVER_PORT"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "5000"
  }

  // set security group for Load Balancer 
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = var.security_group
  }

  depends_on = [aws_elastic_beanstalk_application.mywebapp]
}

#.................................................
# Create a role for codedeploy 
resource "aws_iam_role" "my_beanstalk_role" {
  name = "MyBeanStalkRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            },
            "Action": [
                "sts:AssumeRole"
            ]
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "beanstalk_profile" {
  name = "aws-elasticbeanstalk-ec2-role" # use the same name as the default instance profile

  role = aws_iam_role.my_beanstalk_role.name
}
