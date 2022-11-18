# Create s3 bucket 
resource "aws_s3_bucket" "codebucket" {
  bucket = "${var.codebucket}-${random_integer.suffix.result}"
  #bucket = "${var.codebucket}"

  tags = {
    Name        = var.codebucket
    Environment = "dev"
  }
}

#.................................................
resource "random_integer" "suffix" {
  min = 100
  max = 999
}

#.................................................
#  ***** This one is not being used because we want this to gets called all the time
#.................................................
/*# Upload webapp file to S3 
resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.codebucket.id
  key    = var.zip-file
  source = join("/", [var.zip-path, var.zip-file]) 

  depends_on = [aws_s3_bucket.codebucket]
} */

#.................................................
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

#.................................................
# Attach codedeploy policy to code deploy role 
resource "aws_iam_role_policy_attachment" "codedeploy_service" {
  role       = aws_iam_role.my_code_deploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

#.................................................
# Create Code Deploy application 
resource "aws_codedeploy_app" "myapp" {
  name = var.app-name

  depends_on = [aws_iam_role_policy_attachment.codedeploy_service]
}

#.................................................
# create Deployment group for EC2 machines 
resource "aws_codedeploy_deployment_group" "mydeploygroup" {
  app_name              = aws_codedeploy_app.myapp.name
  deployment_group_name = "${var.app-name}-deploygroup"
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

  depends_on = [aws_codedeploy_app.myapp]
}


#.................................................
# upload zip file to S3 object 
resource "null_resource" "upload_file" { 

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost \
    app_name=${var.app-name} \
    bucket=${aws_s3_bucket.codebucket.id} \
    zip_file=${var.app-name} \
    webapp_src_location=${var.webapp-src-location}" \
  ansible_templates/aws_cmd_execution.yaml
EOF
  } # End of provisioner

  depends_on = [aws_s3_bucket.codebucket , aws_instance.http-server]
} # end of "null_resource" "upload_file"

#.................................................
# Create Deployment and point to S3 object 
resource "null_resource" "perform_deploy" { 

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
aws deploy create-deployment \
  --application-name ${var.app-name} \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name ${aws_codedeploy_deployment_group.mydeploygroup.deployment_group_name} \
  --s3-location bucket=${aws_s3_bucket.codebucket.id},bundleType=zip,key=${var.zip-file}
EOF
  } # End of provisioner

  depends_on = [null_resource.upload_file]
} # end of "null_resource" "perform_deploy" 
