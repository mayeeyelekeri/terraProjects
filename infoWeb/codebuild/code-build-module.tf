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

# Create Code build server project
resource "aws_codebuild_project" "server_project" {
  name          = var.server_project_name
  description   = var.server_project_description
  build_timeout = "5"
  service_role  = aws_iam_role.codebuildrole.arn

  artifacts {
    type     = "S3"
    location = var.codebucket_name
  }

  cache {
    type     = "S3"
    location = var.codebucket_name
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    /*cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    } */

    s3_logs {
      status   = "ENABLED"
      location = "s3://${var.codebucket_name}"
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

  source_version = "master"

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
    type     = "S3"
    location = var.codebucket_name
  }

  cache {
    type     = "S3"
    location = var.codebucket_name
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    /*cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    } */

    s3_logs {
      status   = "ENABLED"
      location = "s3://${var.codebucket_name}"
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

  source_version = "master"

  tags = {
    Environment = "dev"
  }
} 