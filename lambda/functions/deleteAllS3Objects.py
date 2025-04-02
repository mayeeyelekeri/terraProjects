import logging
import boto3
import datetime
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Set up logging
    logging.basicConfig(level=logging.DEBUG,
                        format='%(levelname)s: %(asctime)s: %(message)s')
                        
    bucket_name = 'terraprojects1'
    s3 = boto3.client('s3')
    
    print ('listing the contents of bucket')
    myobjects = s3.list_objects(Bucket=bucket_name)
    mycontents = myobjects.get('Contents', [])
    
    if len(mycontents) > 0:
        
        # List the object names
        logging.info(f'Objects in {bucket_name}')
        count = len(myobjects)
        print(f'Number of items in bucket : {count}')
        
        for obj in mycontents:
            print("going to process object: " + obj['Key'])
            try:
                # s3.delete_object(Bucket=bucket_name, Key=obj["Key"])
                print ("didnt delete")
            except ClientError as e:
                logging.error(e)
        
    return True