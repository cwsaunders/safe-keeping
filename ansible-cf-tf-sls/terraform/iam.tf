resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
} 

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    sid = "AllowInvokingLambdas"
    effect = "Allow"

    resources = [
      "arn:aws:lambda:*:*:function:*"
    ]

    actions = [
      "lambda:InvokeFunction"
    ]

  }

  statement {
    sid = "AllowCreatingLogGroups"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:*"
    ]

    actions = [
      "logs:CreateLogGroup"
    ]
  }

  statement {
    sid = "AllowWritingLogs"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"
    ]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name = "s3-policy"
  description = "A test policy"
  policy = jsonencode(
   {
"Version": "2012-10-17",
"Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "logs:*"
        ],
        "Resource": "arn:aws:logs:*:*:*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": "arn:aws:s3:::*"
    }
    ]
    } 
    )
    }


resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.lambda_exec_role.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}



resource "aws_iam_policy" "push_to_kinesis" {
  name = "lambda-policy-for-kinesis"
  description = "Pushing to Kinesis pls"
  policy = jsonencode(
   {
  "Version": "2012-10-17",
  "Id": "default",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": ["kinesis:PutRecord","kinesis:GetRecord"],
      "Resource": "arn:aws:kinesis:us-east-1:960304447084:stream/s3-to-kinesis-a5739"
    }
  ]
}
    )
    }

resource "aws_iam_role_policy_attachment" "attach_kinesis_policy" {
  role       = "${aws_iam_role.iam_for_lambda_kinesis.name}"
  policy_arn = "${aws_iam_policy.push_to_kinesis.arn}"
}
