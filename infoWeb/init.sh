#### For signature error, run the command
sudo /usr/sbin/ntpdate pool.ntp.org

# Create an S3 bucket for strong terraform state 
aws s3 mb s3://terraprojects --region us-east-1

# In database directory, execute script to create mysql creds in secrets manager 
. ~/INFO/secrets/aws_secrets.sh 
