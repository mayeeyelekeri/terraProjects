####  Git Repo and access token to github coming from AWS Secrets Manager 
####  "repository" and "token"
# Get Github secrets from AWS Secret Manager 
data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = var.git_creds 
}

locals {git_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)}

resource "aws_codebuild_source_credential" "example" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = local.git_creds.token
}



resource "aws_codepipeline" "web_pipeline" {
  name     = "web-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  tags     = {
    Environment = "dev"
  }

  artifact_store {
    location = var.buildbucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
                Owner = "mayeeyelekeri"
                OAuthToken = local.git_creds.token
                #PersonalToken = local.git_creds.token
                Repo = "awspipelinedemo.git"
                Branch = "main"
                PollForSourceChanges = "true"
      }

      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "ThirdParty"
      provider  = "GitHub"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "EnvironmentVariables" = jsonencode(
          [
            {
              name  = "environment"
              type  = "PLAINTEXT"
              value = "dev"
            },
          ]
        )
        "ProjectName" = "static-web-build"
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  } # End of stage "build"
  
} # end of resource pipeline 


data "aws_iam_policy_document" "codepipeline_assume_policy" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["codepipeline.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "codepipeline_role" {
    name = "mypipe-codepipeline-role"
    assume_role_policy = "${data.aws_iam_policy_document.codepipeline_assume_policy.json}"


}

# CodePipeline policy needed to use Github and CodeBuild
resource "aws_iam_role_policy" "attach_codepipeline_policy" {
    name = "mypipe-codepipeline-policy"
    role = aws_iam_role.codepipeline_role.id

    policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketVersioning",
                "s3:PutObject"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudwatch:*",
                "sns:*",
                "sqs:*",
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}



