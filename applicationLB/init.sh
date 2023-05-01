aws s3 mb s3://myterraprojects --region us-east-1

aws ec2 create-key-pair --key-name id_rsa --region us-east-1 --query 'KeyMaterial' --output text > ../../awsKeyPairDir/id_rsa.pem
