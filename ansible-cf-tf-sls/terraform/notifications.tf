resource "aws_s3_bucket_notification" "my-trigger" {
    bucket = aws_s3_bucket.first_bucket.id

    lambda_function {
        lambda_function_arn = aws_lambda_function.s3_to_kinesis.arn
        events              = ["s3:ObjectCreated:*"]
    }
    depends_on = [aws_lambda_permission.lambda_s3_permission_invoke]
}

resource "aws_lambda_permission" "lambda_s3_permission_invoke" {
  statement_id  = "AllowS3Invoke" # AllowS3Invoke AllowExecutionFromS3Bucket
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_to_kinesis.arn
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.first_bucket.arn
  #depends_on = [aws_s3_bucket_notification.bucket_notification, aws_s3_bucket_notification.my-trigger]
}

#resource "aws_s3_bucket_notification" "bucket_notification" {
#  bucket = aws_s3_bucket.first_bucket.id
#  
#  lambda_function {
#    lambda_function_arn = aws_lambda_function.s3_to_kinesis.arn
#    events              = ["s3:ObjectCreated:*"]
#    filter_prefix       = "AWSLogs/"
#    filter_suffix       = ".log"
#  }
#}
