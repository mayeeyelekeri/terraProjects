
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.pipeline_name}"
  role_arn = aws_iam_role.my_code_pipeline_role.arn
 
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

} 
