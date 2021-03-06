AWSTemplateFormatVersion: '2010-09-09'
Description: 'Example Lambda zip copy'
Resources:
  EventBridgeLambdaPermission:
    Type: AWS::Lambda::Permission
    Properties:
      FunctionName: !GetAtt MyFunction.Arn
      Action: lambda:InvokeFunction
      Principal: events.amazonaws.com
      SourceAccount: !Ref AWS::AccountId
      SourceArn: !GetAtt LambdaEvent.Arn
  TxtBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: "{{ common.some_bucket }}"
  MyFunctionRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: 
              - 'lambda.amazonaws.com'
            Action:
            - sts:AssumeRole
      ManagedPolicyArns:
        - 'arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole' ###
      Policies:
        - 
          PolicyName: 'bucket-access'
          PolicyDocument:
            Version: '2012-10-17'
            Id: 'BucketPolicy'
            Statement:
            - Effect: Allow
              Action:
              - s3:ListBucket
              - s3:GetObject
              - s3:GetBucketLocation
              - s3:PutObject
              - s3:PutObjectAcl
              Resource:
              - "arn:aws:s3:::{{ common.some_bucket }}"
              - "arn:aws:s3:::{{ common.some_bucket }}/*"
  MyFunction:
    Type: AWS::Lambda::Function
    Properties:
      Description: Example
      Handler: main.craigslist_scraper ###
      Runtime: python3.8 ###
      Role: !GetAtt 'MyFunctionRole.Arn' ###
      Timeout: 300
      Code:
        S3Bucket: code-for-cf
        S3Key: 'deployment/craigslist-crawler.zip' ###
  LambdaEvent: ###
    Type: 'AWS::Events::Rule'
    Properties:
      Name: "{{ common.some_event }}"
      Description: Triggers Craigslist Scraping
      ScheduleExpression: rate(2 days)
      Targets:
        - Id: LambdaEventTarget
          Arn:
            'Fn::GetAtt':
              - MyFunction
              - Arn
      State: ENABLED
Outputs:
  S3URL:
    Value: !GetAtt [TxtBucket, WebsiteURL]
    Description: URL of S3 Bucket
