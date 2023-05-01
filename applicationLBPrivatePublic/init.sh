aws s3 mb s3://myterraprojects1 --region us-east-1

aws ec2 create-key-pair --key-name mykey --region us-east-1 --query 'KeyMaterial' --output text > ../../awsKeyPairDir/applicationLBPrivatePublic.pem
