
--- Create an S3 bucket for strong terraform state 
aws s3 mb s3://terraprojects --region us-east-1

--- Make sure the web application source directory exists at this location where the terraform is running from 
/home/vagrant/webapp 

--- Make sure "ansible" is installed 

--- Key-pair is from the local machine

--- Create "codepipeline" project by using existing service role with "s3" as source and "codedeploy" as target 

--- To execute 
terraform init -reconfigure 
terraform apply -var-file=dev/terraform.tfvars

