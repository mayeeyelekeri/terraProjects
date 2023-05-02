# Create bean stack application 
resource "aws_elastic_beanstalk_application" "mywebapp" {
  name        = "mywebapp"
  description = "mywebapp"

  depends_on = [null_resource.upload_file, aws_iam_role_policy.ebs_policy]
}

resource "aws_elastic_beanstalk_application_version" "beanstalk_myapp_version" {
  application = aws_elastic_beanstalk_application.mywebapp.name
  bucket = aws_s3_bucket.codebucket.id
  key = var.file-name
  name = "${var.app-name}-1.0.0"

  depends_on = [aws_elastic_beanstalk_application.mywebapp]
}


# Create environment 
resource "aws_elastic_beanstalk_environment" "myapp-env" {
  name = "mywebapp-env"
  application = aws_elastic_beanstalk_application.mywebapp.name
  solution_stack_name = var.stack-name
  version_label = aws_elastic_beanstalk_application_version.beanstalk_myapp_version.name
 
  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t2.micro"
  }

  setting {
   namespace = "aws:autoscaling:launchconfiguration"
   name = "IamInstanceProfile"
   #value = var.instance-profile
   value = "aws-elasticbeanstalk-ec2-role"  # **** this gets created automatically from aws console when an app is created 
  }

  setting {
    name = "SERVER_PORT"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "5000"
  }

  depends_on = [aws_iam_role.beanstackrole, aws_iam_instance_profile.myinstanceprofile, aws_elastic_beanstalk_application.mywebapp]
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

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.codebucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_public_access_block.example
  ]

  bucket = aws_s3_bucket.codebucket.id
  acl    = "public-write"
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


#.................................................
# Create a role for bean stack 
resource "aws_iam_role" "beanstackrole" {
  name = "beanstackrole"

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
} # end of my_code_pipeline_role

# Create a instance profile 
resource "aws_iam_instance_profile" "myinstanceprofile" {
  name = var.instance-profile
  role = aws_iam_role.beanstackrole.name
  path = "/"
} # end of resource aws_iam_instance_profile


# Attach policy to role
resource "aws_iam_role_policy" "ebs_policy" {
  name = "ebs_policy"
  role = aws_iam_role.beanstackrole.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "BucketAccess",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::elasticbeanstalk-*",
                "arn:aws:s3:::elasticbeanstalk-*/*"
            ]
        },
        {
            "Sid": "XRayAccess",
            "Action": [
                "xray:PutTraceSegments",
                "xray:PutTelemetryRecords",
                "xray:GetSamplingRules",
                "xray:GetSamplingTargets",
                "xray:GetSamplingStatisticSummaries"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "CloudWatchLogsAccess",
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
            ]
        },
        {
            "Sid": "ElasticBeanstalkHealthAccess",
            "Action": [
                "elasticbeanstalk:PutInstanceStatistics"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:elasticbeanstalk:*:*:application/*",
                "arn:aws:elasticbeanstalk:*:*:environment/*"
            ]
        },
        {
            "Sid": "ECSAccess",
            "Effect": "Allow",
            "Action": [
                "ecs:Poll",
                "ecs:StartTask",
                "ecs:StopTask",
                "ecs:DiscoverPollEndpoint",
                "ecs:StartTelemetrySession",
                "ecs:RegisterContainerInstance",
                "ecs:DeregisterContainerInstance",
                "ecs:DescribeContainerInstances",
                "ecs:Submit*",
                "ecs:DescribeTasks"
            ],
            "Resource": "*"
        },
        {
            "Sid": "MetricsAccess",
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "QueueAccess",
            "Action": [
                "sqs:ChangeMessageVisibility",
                "sqs:DeleteMessage",
                "sqs:ReceiveMessage",
                "sqs:SendMessage"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "DynamoPeriodicTasks",
            "Action": [
                "dynamodb:BatchGetItem",
                "dynamodb:BatchWriteItem",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:UpdateItem"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:dynamodb:*:*:table/*-stack-AWSEBWorkerCronLeaderRegistry*"
            ]
        }
    ]
  }
EOF

  depends_on = [aws_iam_role.beanstackrole]
}