
--- Create an S3 bucket for strong terraform state 
aws s3 mb s3://terraprojects --region us-east-1

--- Key-pair is from the local machine

--- Create database schema called "info" and import data 
mysql -uadmin -p -h<db_name> 
  create database info; 

mysql -uadmin -p -h<db_name> info < import_data.txt 

--- To execute 
terraform init -reconfigure 
terraform apply -var-file=dev/terraform.tfvars

