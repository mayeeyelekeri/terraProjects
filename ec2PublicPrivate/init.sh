aws s3 mb s3://myterraprojects --region us-east-1

# aws ec2 create-key-pair --key-name ec2PublicPrivate --region us-east-1 --query 'KeyMaterial' --output text > ../../awsKeyPairDir/ec2PublicPrivate.pem

-------  DEVELOPMENT ------------
terraform init 
terraform workspace new dev 
terraform plan  -var-file=dev/terraform.tfvars
terraform apply -auto-approve  -var-file=dev/terraform.tfvars

terraform destroy -auto-approve -var-file=dev/terraform.tfvars

------- PRODUCTION --------------
terraform init 
terraform workspace new prod 
terraform plan  -var-file=prod/terraform.tfvars
terraform apply -auto-approve  -var-file=prod/terraform.tfvars

terraform destroy -auto-approve -var-file=prod/terraform.tfvars
