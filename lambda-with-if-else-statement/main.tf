data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-west-2"
}

locals {
  lambda_src_path = "./lambda"
}

resource "aws_iam_role" "payload" {
  name = var.iam_role_name

  assume_role_policy = <<EOF

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "AWSLambdaBasicExecutionRole" {

  name        = var.iam_policy_name
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:*:*:*"
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.payload.name
  policy_arn = aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "aws_sqs_queue" "terraform_queue" {
  name                      = "terraform-example-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 4
  })

  tags = {
    Environment = "production"
  }
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = aws_sqs_queue.sqs_queue_test.arn
  function_name    = aws_lambda_function.example.arn
}

/*

 resource "aws_dynamodb_table" "basic-db-table" {
  name             = "tf-dynamodb"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "Id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "Id"
    type = "S"
  }
} 

resource "aws_lambda_event_source_mapping" "tf-source" {
  event_source_arn  = aws_dynamodb_table.basic-db-table.stream_arn
  function_name     = aws_lambda_function.payload.arn
  starting_position = "LATEST"
}
*/

resource "null_resource" "archive" {

  provisioner "local-exec" {

    command     = "mkdir -p ./lambda/ && rsync -av --exclude={'*.tf','*.sh','*.tfstate*','*./*','*terraform*','lambda/','*.zip','source/'} ./ ./lambda/ && cd ./lambda && npm install --legacy-peer-deps"
    interpreter = ["/bin/bash", "-c"]
  }

  triggers = {
    /*     dependencies_versions = filemd5("./index.js")
    create_file           = fileexists("./readme.txt")
    updated_at            = timestamp() */
    archive_file = md5("${var.function_name}-payload.zip")

  }
}

data "archive_file" "payload_zip" {
  type        = "zip"
  source_dir  = local.lambda_src_path
  output_path = "./${var.function_name}-payload.zip"
  /*   excludes = [
    "*.terraform*",
    "*.tfstate",
    "*.tf",
    "payload.zip",
    "lambda",
    "*./*"
  ] */

  depends_on = [
    null_resource.archive
  ]
}

resource "aws_lambda_function" "payload" {

  function_name = var.function_name
  filename      = data.archive_file.payload_zip.output_path
  description   = var.description
  role          = aws_iam_role.payload.arn
  handler       = var.lambda_handler
  runtime       = var.compatible_runtimes
  timeout       = 90

  depends_on = [
    aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role,
    data.archive_file.payload_zip,
  ]

  source_code_hash = data.archive_file.payload_zip.output_base64sha256
  publish          = true
}

/* resource "null_resource" "layer_dependencies" {

      triggers = {
 //   dependencies_versions = filemd5("./index.js")
 //   create_file           = fileexists("./readme.txt")
 //   updated_at            = timestamp()
  archive_file = md5("${var.function_name}-layer.zip")

  }

  provisioner "local-exec" {
    command     = "mkdir -p ./source/nodejs/ && rsync -av --exclude={'*.tf','*.sh','*.tfstate*','*./*','*terraform*','lambda/','*.zip','source/'} ./ ./source/nodejs/ && cd ./source/nodejs/ && npm install --legacy-peer-deps && cd -"
    interpreter = ["/bin/bash", "-c"]
  }
}

data "archive_file" "local_layer" {
  type        = "zip"
  source_dir  = local.layer_src_path
  output_path = "./${var.layer_name}-layer.zip"
  depends_on = [
    null_resource.layer_dependencies,
  ]
}

resource "aws_lambda_layer_version" "lambda_layers" {
  count = var.create_layer && var.create != data.archive_file.payload_zip.output_base64sha256 ? 1 : 0
  count = var.create && var.create_layer ? 0 : 1

  filename            = "./${var.layer_name}-layer.zip"
  layer_name          = try(tostring(var.layer_name), null)
  source_code_hash    = filebase64sha256("./${var.layer_name}-layer.zip")
  compatible_runtimes = ["nodejs14.x", "nodejs16.x"]

  skip_destroy          = true

  depends_on = [
    data.archive_file.local_layer,
    null_resource.layer_dependencies
  ]
}
*/