frameworkVersion: '2'
service: cs

provider:
  name: aws
  runtime: python3.8
  lambdaHashingVersion: 20201221
  iam:
    role:
      statements:
        - Effect: Allow
          Action:
            - s3:ListBucket
            - s3:GetObject
            - s3:GetObjectAcl
            - s3:GetBucketLocation
            - s3:PutObject
            - s3:PutObjectAcl
            - 'kinesis:PutRecord'
            - 'kinesis:GetRecord'
            - dynamodb:GetItem
            - dynamodb:PutItem
          Resource:
            - arn:aws:s3:::buckety-boo-bucket/*
            - arn:aws:s3:::kinesis-output-s3-4233/*
            - arn:aws:s3:::kinesis-output-s3-4233
            - arn:aws:dynamodb:us-east-1:960304447084:table/DynamoDB-data_from_kinesis_34
            - Fn::GetAtt:
              - KinesisToDynamoStream
              - Arn
            - Fn::GetAtt:
              - DynamoIsMyName
              - Arn

resources: 
  Resources:
    TxtBucket:
        Type: AWS::S3::Bucket
        Properties:
          BucketName: buckety-boo-bucket
    KinesisToDynamoStream:
      Type: AWS::Kinesis::Stream
      Properties:
        ShardCount: 1
        Name: my-aws-s3-kinesis-datastream
    kinesisOutputSThree:
      Type: AWS::S3::Bucket
      Properties:
        BucketName: kinesis-output-s3-4233
    DynamoIsMyName:
        Type: AWS::DynamoDB::Table
        Properties:
          TableName: DynamoDB-data_from_kinesis_34
          AttributeDefinitions:
            - AttributeName: "JobName"
              AttributeType: "S"
            - AttributeName: "ID"
              AttributeType: "S"
          KeySchema:
            - AttributeName: "JobName"
              KeyType: "HASH"
            - AttributeName: "ID"
              KeyType: "RANGE"
          ProvisionedThroughput:
            ReadCapacityUnits: 5
            WriteCapacityUnits: 5


functions:
  craigslist:
    handler: main.craigslist_scraper
    events:
      - http:
          method: get
          path: craigslist_scraper
  s3ToKinesis:
    handler: dataPipeline.lambda_handler
    events:
      - s3:
          bucket: buckety-boo-bucket
          event: s3:ObjectCreated:*
          existing: true
  kinesisToS3:
    handler: kinesisToOutput.lambda_handler
    events:
      - stream:
          type: kinesis
          arn:
            Fn::GetAtt: [ KinesisToDynamoStream, Arn ] #!GetAtt KinesisToDynamoStream.Arn
          batchSize: 100
          maximumRecordAgeInSeconds: 120
          startingPosition: LATEST
          enabled: true
          functionResponseType: ReportBatchItemFailures
  s3ToDynamoDB:
    handler: s3-to-dynamo.lambda_handler
    events:
      - s3:
          bucket: kinesis-output-s3-4233
          event: s3:ObjectCreated:*
          existing: true

plugins:
  - serverless-python-requirements
