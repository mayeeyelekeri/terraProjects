aws s3 mb s3://simplevpcnoec2 --region us-east-1

aws ec2 create-key-pair --key-name simpleVPCNoEC2 --region us-east-1 --query 'KeyMaterial' --output text > ../../awsKeyPairDir/simpleVPCNoEC2.pem
