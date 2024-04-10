#!/bin/bash 

bucketName=terraprojects 
echo bucketname $bucketName 

if [ $1 ]; then 
	echo inside if condition 
	bucketName=$1 
fi
 
#### For signature error, run the command
sudo /usr/sbin/ntpdate pool.ntp.org

echo bucketname $bucketName 

# specify bucket 
# Create an S3 bucket for strong terraform state 
aws s3 mb s3://$bucketName --region us-east-1

#aws s3 cp ~/INFO/secrets/application-aws.properties s3://$bucketName/

# In database directory, execute script to create mysql creds in secrets manager 
. ~/INFO/secrets/aws_secrets.sh 
