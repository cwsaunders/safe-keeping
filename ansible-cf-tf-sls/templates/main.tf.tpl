provider "aws" {
  region  = "us-east-1"
}


resource "aws_lambda_function" "main_function" {
  filename      = "main-func.zip"
  function_name = "main_function"
  source_code_hash = filebase64sha256("main-func.zip")
  description   = "Original Lambda for Craigslist Scraper Project - TF"
  handler       = "main.craigslist_scraper"
  runtime       = "python3.8"
  timeout = 900
  role = aws_iam_role.lambda_exec_role.arn
}

resource "aws_s3_bucket" "first_bucket" {
  
  bucket = "tf-buckety-boo2"
  acl    = "private"

}

resource "aws_lambda_function" "s3_to_kinesis" {
  filename      = "s3-to-kinesis.zip"
  function_name = "s3_to_kinesis"
  source_code_hash = filebase64sha256("s3-to-kinesis.zip")
  description   = "S3 to Kinesis Lambda for Craigslist Scraper Project - TF"
  handler       = "s3-to-kinesis.lambda_handler"
  runtime       = "python3.8"
  timeout = 900
  role = aws_iam_role.iam_for_lambda_kinesis.arn
}

resource "aws_kinesis_stream" "s3-to-kinesis-a5739" {
  name = "s3-to-kinesis-a5739"
  shard_count = 1
  retention_period = 24
  shard_level_metrics = [
      "IncomingBytes",
      "OutgoingBytes"
  ]
}

# S3 bucket after kinesis
resource "aws_s3_bucket" "kinesis_to_s33745747" {
  
  bucket = "kinesis-to-s33745747"
  acl    = "private"

}

# Send data from kinesis to s3 bucket
resource "aws_lambda_function" "kinesis_to_s3" {
  filename      = "kinesis-to-s3.zip"
  function_name = "kinesis_to_s3"
  source_code_hash = filebase64sha256("kinesis-to-s3.zip")
  description   = "Kinesis to S3 Lambda for Craigslist Scraper Project - TF"
  handler       = "kinesis-to-s3.lambda_handler"
  runtime       = "python3.8"
  timeout = 900
  role = aws_iam_role.iam_for_lambda_kinesis.arn
}

# Add Kinesis as trigger for "kinesis_to_s3" function
resource "aws_lambda_event_source_mapping" "lambda_kinesis_trigger" {
  event_source_arn  = aws_kinesis_stream.s3-to-kinesis-a5739.arn
  function_name     = aws_lambda_function.kinesis_to_s3.arn
  starting_position = "LATEST"
}
