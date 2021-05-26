import boto3
import base64

# Accessing the resource for writing stream data
s3 = boto3.resource('s3',region_name='us-east-1')
ev_lst = []
def lambda_handler(event, context):
    for record in event['Records']:
        #Kinesis data is base64 encoded so decode here
        payload=base64.b64decode(record["kinesis"]["data"])
        ev_lst.append(payload)

    # writing data to S3   
    s3.Object('kinesis-output-s3-4233', 'test.txt').put(Body=str(ev_lst))

    return "Success"
