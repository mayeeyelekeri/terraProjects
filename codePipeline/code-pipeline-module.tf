# Create s3 bucket 
resource "aws_s3_bucket" "pipelinebucket" {
  bucket = "${var.pipeline-bucket}-${random_integer.pipeline-random.result}"
  
  tags = {
    Name        = var.codebucket
    Environment = "dev"
  }
}

#.................................................
resource "random_integer" "pipeline-random" {
  min = 100
  max = 999
}

#.................................................
# Create a role for code pipeline 
resource "aws_iam_role" "my_code_pipeline_role" {
  name = "MyCodePipelineRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codepipeline.amazonaws.com"
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

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.my_code_pipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.pipelinebucket.arn}",
        "${aws_s3_bucket.pipelinebucket.arn}/*"
      ]
    },

    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

