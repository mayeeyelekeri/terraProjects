#.................................................
# Create Code Deploy application 
resource "aws_codedeploy_app" "myapp" {
  name = var.app_name

  depends_on = [aws_iam_role_policy_attachment.codedeploy_service]
}

#.................................................
# create Deployment group for EC2 machines 
resource "aws_codedeploy_deployment_group" "mydeploygroup" {
  app_name              = aws_codedeploy_app.myapp.name
  deployment_group_name = "${var.app_name}-deploygroup"
  service_role_arn      = aws_iam_role.my_code_deploy_role.arn
  autoscaling_groups    = [var.auto_scale_group_name ]

  tags = {
    Name = "${terraform.workspace}-deploygroup"
    ALB  = var.alb_dns
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_codedeploy_app.myapp]
}

#.................................................
# Create Deployment and point to S3 object 
# Deployment log located at /opt/codedeploy-agent/deployment-root/deployment-logs/codedeploy-agent-deployments.log on ec2 server 
#.................................................
resource "null_resource" "perform_deploy" { 

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
aws deploy create-deployment \
  --application-name ${var.app_name} \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name ${aws_codedeploy_deployment_group.mydeploygroup.deployment_group_name} \
  --s3-location bucket=${var.codebucket_name},bundleType=zip,key=${var.app_name}/${var.zip_file}
EOF
  } # End of provisioner

  depends_on = [aws_codedeploy_deployment_group.mydeploygroup]
} # end of "null_resource" "perform_deploy"
 