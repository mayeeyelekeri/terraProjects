#.................................................
# Create Code Deploy application 
resource "aws_codedeploy_app" "myapp_client" {
  name = var.app_name_client

  depends_on = [aws_iam_role_policy_attachment.codedeploy_service]
}

#.................................................
# create Deployment group for EC2 machines 
resource "aws_codedeploy_deployment_group" "mydeploygroup_client" {
  app_name              = aws_codedeploy_app.myapp_client.name
  deployment_group_name = "${var.app_name_client}-deploygroup-client"
  service_role_arn      = aws_iam_role.my_code_deploy_role.arn
  autoscaling_groups    = [var.auto_scale_group_name_client ]

  tags = {
    Name = "${terraform.workspace}-deploygroup-client"
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

  depends_on = [aws_codedeploy_app.myapp_client ]
}

/* 
#.................................................
# upload zip file to S3 object 
resource "null_resource" "upload_file_client" { 

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost \
    app_name=${var.app_name_client} \
    bucket=${aws_s3_bucket.codebucket.id} \
    zip_file=${var.app_name_client} \
    webapp_src_location=${var.webapp_src_location_client}" \
  ansible_templates/aws_cmd_execution.yaml
EOF
  } # End of provisioner

  depends_on = [aws_s3_bucket.codebucket, aws_codedeploy_deployment_group.mydeploygroup_client, null_resource.perform_deploy_server, null_resource.create_client_package]
} # end of "null_resource" "upload_file"
*/ 

#.................................................
# This resource is to make wait for build of client to complete 
#.................................................
/*resource "null_resource" "wait_on_client_build" { 

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
echo ${var.create_client_package_id}
EOF
  } # End of provisioner

  
} # end of "null_resource" 
*/ 

#.................................................
# Create Deployment and point to S3 object 
# Deployment log located at /opt/codedeploy-agent/deployment-root/deployment-logs/codedeploy-agent-deployments.log on ec2 server 
#.................................................
resource "null_resource" "perform_deploy_client" { 

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
aws deploy create-deployment \
  --application-name ${var.app_name_client} \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name ${aws_codedeploy_deployment_group.mydeploygroup_client.deployment_group_name} \
  --s3-location bucket=${var.codebucket_name},bundleType=zip,key=${var.client_project_name}/${var.zip_file_client}
EOF
  } # End of provisioner

  depends_on = [null_resource.upload_file_client]
} # end of "null_resource" "perform_deploy_client"
 