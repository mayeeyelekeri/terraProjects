
--- Create an S3 bucket for strong terraform state 
aws s3 mb s3://terraprojects --region us-east-1

--- Make sure the spring boot web application source directory exists at this location where the terraform is running from 
/home/vagrant/springdemo/target 

--- Make sure "ansible" is installed 

--- To execute 
terraform init -reconfigure 
terraform apply -var-file=dev/terraform.tfvars

