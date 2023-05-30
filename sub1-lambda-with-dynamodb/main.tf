data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-west-2"
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
  role             = aws_iam_role.lambda_assume_role.arn
  runtime          = "python3.8"

  lifecycle {
    create_before_destroy = true
  }
}

data "archive_file" "lambda_zip_file" {
  output_path = "${path.module}/lambda_zip/lambda.zip"
  source_dir  = "${path.module}/../lambda"
  excludes    = ["__init__.py", "*.pyc"]
  type        = "zip"
}
/*
 module "lambda" {
  source = "../modules/lambda"

  iam_role_name       = "tf-lambda-iam-role-sub1"
  iam_policy_name     = "tf-lambda-policy-sub1"
  function_name       = "tf-lambda-sub1"
  lambda_handler      = "index.handler"
  compatible_runtimes = "nodejs14.x"
  dir                 = "sub1"
} */