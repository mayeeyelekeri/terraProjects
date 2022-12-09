
--- Create an S3 bucket for strong terraform state 
aws s3 mb s3://terraprojects --region us-east-1

--- In database directory, execute script to create mysql creds in secrets manager 
. ~/INFO/secrets/aws_secrets.sh 

--- Make sure the web application source directory exists at this location where the terraform is running from 
/home/vagrant/SpringDataTest and /home/vagrant/Client exists 

--- Make sure "ansible" is installed 

--- Key-pair is from the local machine

--- This project is going to create 2 ec2s - one for server and other for client. 

--- This project depends on database is already created with data  

--- In Client module, update Servers IP address at application.properties 

--- To execute 
terraform init -reconfigure 
terraform apply -var-file=dev/terraform.tfvars

-------------------- Resources Created --------------------------------
- VPC with CIDR 10.0.0.0/24

- 2 public subnets 
  10.0.0.0/26     us-east-1a 
  10.0.0.64/26    us-east-1b 

- 2 private subnets 
  10.0.0.128/26  us-east-1a 
  10.0.0.192/26  us-east-1b 

- Gateways 
  Internet Gateway attached to VPC
  NAT Gateway in Public subnets 10.0.0.0/26

- Security Groups 
  Public with 22,80 and 8080 access from 0.0.0.0/0
  Private with 22,80 and 8080 access  from public subnets 

- Load Balancer (Client module)
  Application Load Balancer
     public group access 
     Will be serving public subnets 
  Target Group 
     Port where application is running 
     Health check hyperlink 
  Listener 
     Link Target group 

  *** Repeat Load Balancer for Info module for private subnet  

- AutoScaling 
  Import local key to AWS 
  Create an Instance profile for EC2 
  Create Launch configuration based on Amazon Linux ami
    Attach instanceprofile 
    Add "user_data" to install docker and codedeploy agent 
  Create Auto-scaling group (**** for both client and server)
    Attach launch configuration
    Attach target group create in ALB module 

- CodeDeploy 
  New codedeploy bucket (random postfix)
  Instance profile for codedeploy 

 **** Below tasks are performed for both client and server 
 Create codedeploy application 
  Create codedeploy deployment group 
     group name is the one created in autoscaling module 
  Upload application zipfile to bucket 
  Initiate deploy 
