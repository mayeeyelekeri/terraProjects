####  Git Repo and access token to github coming from AWS Secrets Manager 
####  "repository" and "token"
# Get Github secrets from AWS Secret Manager 
data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = var.git_creds 
}

locals {git_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)}


# create service role for codebuild 
resource "aws_iam_role" "codebuildrole" {
  name = "codebuildrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#.................................................
resource "random_integer" "suffix" {
  min = 100
  max = 999
}

# Create s3 bucket 
resource "aws_s3_bucket" "codebuildbucket" {
  bucket = "${var.buildbucket_name}-${random_integer.suffix.result}"

  tags = {
    Name        = var.buildbucket_name
    Environment = "dev"
  }
}

/* Codebuild only allows a single credential per given server type in a given region. 
   Therefore, when you define aws_codebuild_source_credential, aws_codebuild_project resource defined in the same module will use it. 
*/ 
resource "aws_codebuild_source_credential" "example" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = local.git_creds.token
}


# IAM policy for the CodeBuild role
resource "aws_iam_policy" "codebuild_myapp_build_policy" {
  name = "mycompany-codebuild-policy-myapp-build-us-east-1"
  description = "Managed by Terraform"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:GetAuthorizationToken",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "logs:CreateLogStream",
                "github:GitPull",
                "logs:PutLogEvents",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:logs:us-east-1:000000000000:log-group:/aws/codebuild/myapp-build",
                "arn:aws:logs:us-east-1:000000000000:log-group:/aws/codebuild/myapp-build:*",
                "arn:aws:s3:::codepipeline-us-east-1-*",
                "arn:aws:codecommit:us-east-1:000000000000:mycompany-devops-us-east-1"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": [
                "arn:aws:logs:us-east-1:000000000000:log-group:/aws/codebuild/myapp-build",
                "arn:aws:logs:us-east-1:000000000000:log-group:/aws/codebuild/myapp-build:*"
            ]
        }
    ]
}
POLICY
} 


# attach the policy
resource "aws_iam_role_policy_attachment" "codebuild_myapp_build_policy_att" {
    role       = "${aws_iam_role.codebuildrole.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


# Create Code build server project
resource "aws_codebuild_project" "server_project" {
  name          = var.server_project_name
  description   = var.server_project_description
  build_timeout = "5"
  service_role  = aws_iam_role.codebuildrole.arn

  artifacts {
    type      = "S3"
    location  = aws_s3_bucket.codebuildbucket.id
    #packaging = "ZIP"
    #name      = "${var.server_project_name}.zip"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuildbucket.id
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "BUCKET_NAME"
      value = var.state_bucket_name
    }

  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED"
      group_name  = "log-group"
      stream_name = "log-stream"
    } 

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuildbucket.id}/logs/server"
    } 
  }

  source {
    type            = "GITHUB"
    location        = local.git_creds.server_git_repository
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  tags = {
    Environment = "dev"
  }
}  # End of server project 

# Create Code build Client project
resource "aws_codebuild_project" "client_project" {
  name          = var.client_project_name
  description   = var.client_project_description
  build_timeout = "5"
  service_role  = aws_iam_role.codebuildrole.arn

  artifacts {
    type      = "S3"
    location  = aws_s3_bucket.codebuildbucket.id
    #packaging = "ZIP"
    #name      = "${var.client_project_name}.zip"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuildbucket.id
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "BUCKET_NAME"
      value = aws_s3_bucket.codebuildbucket.id
    }

    environment_variable { 
      name  = "ALB_SERVER_DNS"
      value = var.alb_server_dns
    }
  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED"
      group_name  = "log-group"
      stream_name = "log-stream"
    } 

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuildbucket.id}/logs/client"
    } 
  }

  source {
    type            = "GITHUB"
    location        = local.git_creds.client_git_repository
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  tags = {
    Environment = "dev"
  }
} 

/*resource "aws_codebuild_webhook" "example" {
  project_name = aws_codebuild_project.client_project.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "BASE_REF"
      pattern = "master"
    }
  }
} */

#.................................................
# Start codebuild for Server project  
resource "null_resource" "start_server_build" { 

  # This timestamps makes this resource to run all time, even if there is no change
  #triggers = {
  #  always_run = "${timestamp()}"
  #}  
   
  provisioner "local-exec" {
    command = <<EOF
../modules/codebuild/start-codebuild-project.sh ${var.server_project_name}
EOF
  } # End of provisioner
  /*
  # ************* commented ********* 
  provisioner "local-exec" {
    command = <<EOF
echo *********** skipping server build **********  
EOF
  }    */

  depends_on = [aws_codebuild_project.server_project]
} # end of "null_resource" "start_server_build"


#.................................................
# Start codebuild for Client project  
resource "null_resource" "start_client_build" { 

  # This timestamps makes this resource to run all time, even if there is no change
  #triggers = {
  #  always_run = "${timestamp()}"
  #}
  
  provisioner "local-exec" {
    command = <<EOF
../modules/codebuild/start-codebuild-project.sh ${var.client_project_name}
EOF
  } # End of provisioner
  /*
  # ********************* comments ************* 
  provisioner "local-exec" {
    command = <<EOF
echo *********** skipping client build **********  
EOF
  } */ 
  depends_on = [aws_codebuild_project.client_project, null_resource.start_server_build]
} # end of "null_resource" "start_client_build"
