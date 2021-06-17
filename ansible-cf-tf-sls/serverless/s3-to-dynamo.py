import boto3
import re

s3_client = boto3.resource('s3')
dynamodb = boto3.client('dynamodb')
bucket = s3_client.Bucket('kinesis-output-s3-4233')

def lambda_handler(event, context):
    for obj in bucket.objects.all():
        key = obj.key
        body = obj.get()['Body'].read()
        print(body)
        # regex
        patternId = b"'id\\\\\\': \\\\\\'[0-9]*\\\\\\'"
        patternName = b"'name\\\\\\': (\\\\\\'.*?')"
        IdLine = re.findall(patternId, body)
        NameLine = re.findall(patternName, body)
        for i in range(len(IdLine)):
            try:
                tempStringId = str(IdLine[i])
                tempStringName = str(NameLine[i])
                dynamodb.put_item(TableName='DynamoDB-data_from_kinesis_34', Item={'JobName':{'S':f'{tempStringName}'}, 'ID':{'S':f'{tempStringId}'}})
            except:
                break

    return "Success"
