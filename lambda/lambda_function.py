import json
import os
import boto3

#from base64 import b64decode 
#aws_client = boto3.client('ssm')
#ssm_message_decrpyted = aws_client.get_parameter( Name='message', WithDecryption=True)

def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Hello to Lambda , Mr.' + os.environ['myname'])
        #'body': json.dumps('Hello to Lambda , Mr.' + os.environ['myname'] + ', this is the message from Systems Manager ....' + ssm_message_decrpyted)
    }
