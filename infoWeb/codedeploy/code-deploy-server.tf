#.................................................
# Create Code Deploy application 
resource "aws_codedeploy_app" "myapp" {
  name = var.app_name_server

  depends_on = [aws_iam_role_policy_attachment.codedeploy_service]
}

#.................................................
# create Deployment group for EC2 machines 
resource "aws_codedeploy_deployment_group" "mydeploygroup" {
  app_name              = aws_codedeploy_app.myapp.name
  deployment_group_name = "${var.app_name_server}-deploygroup"
  service_role_arn      = aws_iam_role.my_code_deploy_role.arn
  autoscaling_groups    = [var.auto_scale_group_name_server ]

  tags = {
    Name = "${terraform.workspace}-deploygroup"
    ALB  = var.alb_dns_server
    Environment = "${terraform.workspace}"
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
resource "null_resource" "upload_file_server" { 

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost \
    app_name=${var.app_name_server} \
    bucket=${aws_s3_bucket.codebucket.id} \
    zip_file=${var.app_name_server} \
    webapp_src_location=${var.webapp_src_location_server}" \
  ansible_templates/aws_cmd_execution.yaml
EOF
  } # End of provisioner

  depends_on = [aws_codedeploy_deployment_group.mydeploygroup]
} # end of "null_resource" "upload_file"

#.................................................
# Create Deployment and point to S3 object 
# Deployment log located at /opt/codedeploy-agent/deployment-root/deployment-logs/codedeploy-agent-deployments.log on ec2 server 
#.................................................
resource "null_resource" "perform_deploy_server" { 

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
aws deploy create-deployment \
  --application-name ${var.app_name_server} \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name ${aws_codedeploy_deployment_group.mydeploygroup.deployment_group_name} \
  --s3-location bucket=${aws_s3_bucket.codebucket.id},bundleType=zip,key=${var.zip_file_server}
EOF
  } # End of provisioner

  depends_on = [null_resource.upload_file_server]
} # end of "null_resource" "perform_deploy"
 