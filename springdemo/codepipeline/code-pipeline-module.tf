


resource "aws_codepipeline" "codepipeline" {
  name     = "${var.pipeline_name}"
  role_arn = aws_iam_role.my_code_pipeline_role.arn
 
  artifact_store {
        location = aws_s3_bucket.pipelinebucket.bucket
        type     = "S3"
  }

  stage {
    name = "Build"

    action {
      name             = "build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
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
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName = "${var.project_name}"
        DeploymentGroupName = "${var.deploy_group_name}"
      }
    }
  } // end of stage "Deploy" 
} 
