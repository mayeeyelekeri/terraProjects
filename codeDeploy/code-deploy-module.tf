# Create s3 bucket 
resource "aws_s3_bucket" "codebucket" {
  #bucket = "${var.codebucket}-${random_integer.suffix.result}"
  bucket = "${var.codebucket}"

  tags = {
    Name        = var.codebucket
    Environment = "Dev"
  }
}

/* resource "random_integer" "suffix" {
  min = 100
  max = 999
} */


# Upload webapp file to S3 
resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.codebucket.id
  key    = var.zip-file
  source = join("/", [var.zip-path, var.zip-file]) 
}

# Create a role for codedeploy 
resource "aws_iam_role" "my_code_deploy_role" {
  name = "MyCodeDeployRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.amazonaws.com"
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

# Create Code Deploy application 
resource "aws_codedeploy_app" "myapp" {
  name = "myapp"
}

# create Deployment group for EC2 machines 
resource "aws_codedeploy_deployment_group" "mydeploygroup" {
  app_name              = aws_codedeploy_app.myapp.name
  deployment_group_name = "mydeploygroup"
  service_role_arn      = aws_iam_role.my_code_deploy_role.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "dev-httpserver"
    }
  }

  /*trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "example-trigger"
    trigger_target_arn = aws_sns_topic.example.arn
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
  } */
}

# s3://codedeploy4321/webapp.zip

# Create Deployment and point to S3 object 

