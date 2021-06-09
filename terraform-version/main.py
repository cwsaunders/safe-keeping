import time
from datetime import date
import boto3
import os
import json

def craigslist_scraper(event,context):
    encoded_string = '{"Craigslist Data:": "Successful"}'
    filename = 'Success.txt'
    bucket_name = "tf-buckety-boo2"
    lambda_path = "/tmp/" + filename
    s3_path = "/100001/20180223/" + filename

    # S3
    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=encoded_string)

    # Return JSON of CraigslistJobs
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Craigslist Data:": "Successful"
        })
    }
