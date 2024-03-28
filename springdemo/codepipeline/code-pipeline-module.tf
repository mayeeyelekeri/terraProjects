
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.pipeline_name}"
  role_arn = aws_iam_role.my_code_pipeline_role.arn
 
  artifact_store {
        location = aws_s3_bucket.pipelinebucket.bucket
        type     = "S3"
  }

   stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "ThirdParty"
      provider = "GitHub"
      version = "1"
      output_artifacts = ["source_output"]

      configuration = {
        OAuthToken = local.git_creds.token
        Owner = "https://github.com/mayeeyelekeri"
        // Repo = local.git_creds.springboot_git_repository
        Repo = "springdemo2"
        Branch = "main"
      }
    }
  } // end of stage "Source"

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "${var.project_name}"
      }
    }
  } // end of stage "Build"

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ApplicationName = "${var.project_name}"
        DeploymentGroupName = "${var.deploy_group_name}"
      }
    }
  } // end of stage "Deploy" 
} 

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
