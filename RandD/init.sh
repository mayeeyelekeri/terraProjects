aws s3 mb s3://terraprojects --region us-east-1

aws ec2 create-key-pair --key-name RandD --region us-east-1 --query 'KeyMaterial' --output text > ../../awsKeyPairDir/RandD.pem
