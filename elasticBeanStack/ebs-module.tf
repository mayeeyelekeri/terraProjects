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
   value = aws_iam_instance_profile.myinstanceprofile.name
   #value = "aws-elasticbeanstalk-ec2-role"  # **** this gets created automatically from aws console when an app is created 
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

  #block_public_acls       = false
  block_public_policy     = false
  #ignore_public_acls      = false
  restrict_public_buckets = false
}

/*resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_public_access_block.example
  ]

  bucket = aws_s3_bucket.codebucket.id
  acl    = "public-read-write"
} */

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
            "Effect": "Allow",
            "Action": [
                "acm:Describe*",
                "acm:List*",
                "autoscaling:Describe*",
                "cloudformation:Describe*",
                "cloudformation:Estimate*",
                "cloudformation:Get*",
                "cloudformation:List*",
                "cloudformation:Validate*",
                "cloudtrail:LookupEvents",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "codecommit:Get*",
                "codecommit:UploadArchive",
                "ec2:AllocateAddress",
                "ec2:AssociateAddress",
                "ec2:AuthorizeSecurityGroup*",
                "ec2:CreateLaunchTemplate*",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteLaunchTemplate*",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteTags",
                "ec2:Describe*",
                "ec2:DisassociateAddress",
                "ec2:ReleaseAddress",
                "ec2:RevokeSecurityGroup*",
                "ecs:CreateCluster",
                "ecs:DeRegisterTaskDefinition",
                "ecs:Describe*",
                "ecs:List*",
                "ecs:RegisterTaskDefinition",
                "elasticbeanstalk:*",
                "elasticloadbalancing:Describe*",
                "iam:GetRole",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfiles",
                "iam:ListRolePolicies",
                "iam:ListRoles",
                "iam:ListServerCertificates",
                "logs:Describe*",
                "rds:Describe*",
                "s3:ListAllMyBuckets",
                "sns:ListSubscriptionsByTopic",
                "sns:ListTopics",
                "sqs:ListQueues"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:*"
            ],
            "Resource": [
                "arn:aws:autoscaling:*:*:launchConfiguration:*:launchConfigurationName/awseb-e-*",
                "arn:aws:autoscaling:*:*:launchConfiguration:*:launchConfigurationName/eb-*",
                "arn:aws:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/awseb-e-*",
                "arn:aws:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/eb-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:CancelUpdateStack",
                "cloudformation:ContinueUpdateRollback",
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:GetTemplate",
                "cloudformation:ListStackResources",
                "cloudformation:SignalResource",
                "cloudformation:TagResource",
                "cloudformation:UntagResource",
                "cloudformation:UpdateStack"
            ],
            "Resource": [
                "arn:aws:cloudformation:*:*:stack/awseb-*",
                "arn:aws:cloudformation:*:*:stack/eb-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DeleteAlarms",
                "cloudwatch:PutMetricAlarm"
            ],
            "Resource": [
                "arn:aws:cloudwatch:*:*:alarm:awseb-*",
                "arn:aws:cloudwatch:*:*:alarm:eb-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:CreateProject",
                "codebuild:DeleteProject",
                "codebuild:StartBuild"
            ],
            "Resource": "arn:aws:codebuild:*:*:project/Elastic-Beanstalk-*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:CreateTable",
                "dynamodb:DeleteTable",
                "dynamodb:DescribeTable",
                "dynamodb:TagResource"
            ],
            "Resource": [
                "arn:aws:dynamodb:*:*:table/awseb-e-*",
                "arn:aws:dynamodb:*:*:table/eb-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:RebootInstances",
                "ec2:TerminateInstances"
            ],
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/aws:cloudformation:stack-id": [
                        "arn:aws:cloudformation:*:*:stack/awseb-e-*",
                        "arn:aws:cloudformation:*:*:stack/eb-*"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "ec2:RunInstances",
            "Resource": "*",
            "Condition": {
                "ArnLike": {
                    "ec2:LaunchTemplate": "arn:aws:ec2:*:*:launch-template/*"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecs:DeleteCluster"
            ],
            "Resource": "arn:aws:ecs:*:*:cluster/awseb-*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:*Rule",
                "elasticloadbalancing:*Tags",
                "elasticloadbalancing:SetRulePriorities",
                "elasticloadbalancing:SetSecurityGroups"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:*"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:targetgroup/awseb-*",
                "arn:aws:elasticloadbalancing:*:*:targetgroup/eb-*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/awseb-*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/eb-*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/*/awseb-*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/*/eb-*/*",
                "arn:aws:elasticloadbalancing:*:*:listener/awseb-*",
                "arn:aws:elasticloadbalancing:*:*:listener/eb-*",
                "arn:aws:elasticloadbalancing:*:*:listener/*/awseb-*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener/*/eb-*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/app/awseb-*/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/app/eb-*/*/*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:AddRoleToInstanceProfile",
                "iam:CreateInstanceProfile",
                "iam:CreateRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/aws-elasticbeanstalk*",
                "arn:aws:iam::*:instance-profile/aws-elasticbeanstalk*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:AttachRolePolicy"
            ],
            "Resource": "arn:aws:iam::*:role/aws-elasticbeanstalk*",
            "Condition": {
                "StringLike": {
                    "iam:PolicyArn": [
                        "arn:aws:iam::aws:policy/AWSElasticBeanstalk*",
                        "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalk*"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::*:role/*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": [
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com",
                        "ec2.amazonaws.com.cn",
                        "autoscaling.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "ecs.amazonaws.com",
                        "cloudformation.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling*",
                "arn:aws:iam::*:role/aws-service-role/elasticbeanstalk.amazonaws.com/AWSServiceRoleForElasticBeanstalk*",
                "arn:aws:iam::*:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing*",
                "arn:aws:iam::*:role/aws-service-role/managedupdates.elasticbeanstalk.amazonaws.com/AWSServiceRoleForElasticBeanstalk*",
                "arn:aws:iam::*:role/aws-service-role/maintenance.elasticbeanstalk.amazonaws.com/AWSServiceRoleForElasticBeanstalk*"
            ],
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "managedupdates.elasticbeanstalk.amazonaws.com",
                        "maintenance.elasticbeanstalk.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:DeleteLogGroup",
                "logs:PutRetentionPolicy"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "rds:*DBSubnetGroup",
                "rds:AuthorizeDBSecurityGroupIngress",
                "rds:CreateDBInstance",
                "rds:CreateDBSecurityGroup",
                "rds:DeleteDBInstance",
                "rds:DeleteDBSecurityGroup",
                "rds:ModifyDBInstance",
                "rds:RestoreDBInstanceFromDBSnapshot"
            ],
            "Resource": [
                "arn:aws:rds:*:*:db:*",
                "arn:aws:rds:*:*:secgrp:awseb-e-*",
                "arn:aws:rds:*:*:secgrp:eb-*",
                "arn:aws:rds:*:*:snapshot:*",
                "arn:aws:rds:*:*:subgrp:awseb-e-*",
                "arn:aws:rds:*:*:subgrp:eb-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:Delete*",
                "s3:Get*",
                "s3:Put*"
            ],
            "Resource": "arn:aws:s3:::elasticbeanstalk-*/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket",
                "s3:GetBucket*",
                "s3:ListBucket",
                "s3:PutBucketPolicy"
            ],
            "Resource": "arn:aws:s3:::elasticbeanstalk-*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sns:CreateTopic",
                "sns:DeleteTopic",
                "sns:GetTopicAttributes",
                "sns:Publish",
                "sns:SetTopicAttributes",
                "sns:Subscribe",
                "sns:Unsubscribe"
            ],
            "Resource": "arn:aws:sns:*:*:ElasticBeanstalkNotifications-*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sqs:*QueueAttributes",
                "sqs:CreateQueue",
                "sqs:DeleteQueue",
                "sqs:SendMessage",
                "sqs:TagQueue"
            ],
            "Resource": [
                "arn:aws:sqs:*:*:awseb-e-*",
                "arn:aws:sqs:*:*:eb-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecs:TagResource"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ecs:CreateAction": [
                        "CreateCluster",
                        "RegisterTaskDefinition"
                    ]
                }
            }
        }
    ]
}
EOF

  depends_on = [aws_iam_role.beanstackrole]
}