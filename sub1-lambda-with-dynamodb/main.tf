data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "new_role_for_tf" {
  name = "tf-lambda-dynamodb-role"
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
      "Sid": "LambdaAssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dynamodb_read_log_policy-tf" {
  name   = "lambda-dynamodb-tf-log-policy"
  role   = aws_iam_role.new_role_for_tf.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [ "logs:*" ],
        "Effect": "Allow",
        "Resource": [ "arn:aws:logs:*:*:*" ]
    },
    {
        "Action": [ "dynamodb:BatchGetItem",
                    "dynamodb:GetItem",
                    "dynamodb:GetRecords",
                    "dynamodb:Scan",
                    "dynamodb:GetShardIterator",
                    "dynamodb:DescribeStream",
                    "dynamodb:ListStreams" ],
        "Effect": "Allow",
        "Resource": [
          "${aws_dynamodb_table.basic-db-table.arn}",
          "${aws_dynamodb_table.basic-db-table.arn}/*"
        ]
    }
  ]
}
EOF
}

resource "aws_dynamodb_table" "basic-db-table" {
    name = "tf-dynamodb"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "Id"
    stream_enabled   = true
    stream_view_type = "NEW_AND_OLD_IMAGES"

    attribute {
      name = "Id"
      type = "S"
    }
}

resource "aws_lambda_function" "tf-lambda-with-dynamodb" {
  function_name    = "tf-lambda-with-dynamodb"
  filename         = data.archive_file.lambda_zip_file.output_path
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  handler          = "handler.handler"
  role             = aws_iam_role.new_role_for_tf.arn
  runtime          = "python3.8"

  lifecycle {
    create_before_destroy = true
  }
}

data "archive_file" "lambda_zip_file" {
  output_path = "./lambda.zip"
  source_dir  = "./lambda"
  excludes    = ["__init__.py", "*.pyc"]
  type        = "zip"
}