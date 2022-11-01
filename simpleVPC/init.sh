aws s3 mb s3://myterraprojects --region us-east-1

aws ec2 create-key-pair --key-name simpleVPC --region us-east-1 --query 'KeyMaterial' --output text > ../../awsKeyPairDir/simpleVPC.pem
