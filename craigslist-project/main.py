from craigslist import CraigslistJobs
import time
from datetime import date
import boto3
import os
import json

def craigslist_scraper(event,context):
    string = ""
    testVar = CraigslistJobs(site='maine')
    filename = f'{date.today()}' + '.txt'
    while True:
        for result in testVar.get_results(sort_by='newest', limit=15, geotagged=True):
            string += f'{date.today()}' + ":\n"
            string += f'{result}'
        break
    
    
    encoded_string = string.encode("utf-8")

    bucket_name = "buckety-boo-bucket"
    lambda_path = "/tmp/" + filename
    s3_path = "/100001/20180223/" + filename

    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=encoded_string)
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Craigslist Data:": f"{encoded_string}"
        })
    }
