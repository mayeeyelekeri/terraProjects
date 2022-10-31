# terraProjects

Before working on any of these projects, the following actions are required:
1) Create an S3 bucket named "myterraprojects"
2) Create a new key pair named "simpleVPC.pem" and download it to /c/dev/awsKeyPairDir
3) From command line, perform "aws configure"
4) From command line, in workspace, "terraform init -reconfigure" 

EX: 
Create bucket - aws s3 mb s3://myterraprojects --region us-east-1

Generate Key Pair - aws ec2 create-key-pair --key-name simpleVPC --query 'KeyMaterial' --output text > ../../awsKeyPairDir/simpleVPC.pem
