resource "aws_iam_role" "iam_for_lambda_kinesis" {
  name = "lambda-basic-execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Lambda

## Lambda Basic Exectution Role
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role = aws_iam_role.iam_for_lambda_kinesis.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

## Lambda Kinesis Policy
resource "aws_iam_role_policy_attachment" "kinesis_execution" {
  role = aws_iam_role.iam_for_lambda_kinesis.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}

resource "aws_iam_role_policy_attachment" "kinesis-s3-attach" {
  role       = aws_iam_role.iam_for_lambda_kinesis.name
  policy_arn = aws_iam_policy.policy.arn
}
