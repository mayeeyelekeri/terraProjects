
# Create an S3 bucket for strong terraform state 
aws s3 mb s3://terraprojects1 --region us-east-1

# In database directory, execute script to create mysql creds in secrets manager 
. ~/INFO/secrets/aws_secrets.sh 
