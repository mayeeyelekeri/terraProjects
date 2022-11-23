
--- Create an S3 bucket for strong terraform state 
aws s3 mb s3://terraprojects --region us-east-1

--- Make sure the web application source directory exists at this location where the terraform is running from 
/home/vagrant/webapp 

--- Make sure "ansible" is installed 

--- Key-pair is from the local machine

--- This project is going to create 2 ec2s - one for server and other for client. 

--- This project depends on "mysql" project 

--- In Server module, update database host name at application-aws.properties 

--- In Client module, update Servers IP address at application.properties 

--- To execute 
terraform init -reconfigure 
terraform apply -var-file=dev/terraform.tfvars

