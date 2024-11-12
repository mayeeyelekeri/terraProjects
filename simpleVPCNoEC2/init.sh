aws s3 mb s3://myterraprojects --region us-east-1

#aws ec2 create-key-pair --key-name simpleVPCNoEC2 --region us-east-1 --query 'KeyMaterial' --output text > ../../awsKeyPairDir/simpleVPCNoEC2.pem

#Terraform commands 
#1) terraform init -reconfigure 
#2) terraform workspace new dev 
#3) terraform plan -var-file=dev/terraform.tfvars
#4) terraform apply -var-file=dev/terraform.tfvar -auto-approve 
#5) terraform destroy -var-file=dev/terraform.tfvar -auto-approve 
