provider "aws" {
  region = "us-west-2"
}

locals {
  lambda_src_path = "./lambda"
  create          = var.create

  /*   layer_src_path  = "./source"
  destination_dir = "${path.module}./layers/${var.layer_name}" */
}

resource "random_string" "suffix" {
  length = 16
  special = false
}

resource "aws_iam_role" "payload" {

  name = "${var.iam_role_name}-${random_string.suffix.result}"

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
   
  name        = "${var.iam_policy_name}-${random_string.suffix.result}"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.payload.name
  policy_arn = aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "null_resource" "archive" {

  triggers = {
    dependencies_versions = filemd5("./index.js")
    create_file           = fileexists("./readme.txt")
    updated_at            = timestamp()

  }
  provisioner "local-exec" {

    command     = "mkdir -p ./lambda/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip','*.tfvars'} ./ ./lambda/ && cd ./lambda && npm install --legacy-peer-deps"
    interpreter = ["/bin/bash", "-c"]
  }
}

data "archive_file" "payload_zip" {
  type        = "zip"
  source_dir  = local.lambda_src_path
  output_path = "${var.function_name}-payload.zip"
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

resource "time_sleep" "wait_20_seconds" {
  depends_on = [
    null_resource.archive
  ]

  create_duration = "20s"
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
    null_resource.archive
  ]

  source_code_hash = data.archive_file.payload_zip.output_base64sha256
  publish          = true
}

/* data "aws_lambda_function" "lambda" {
  function_name = var.function_name
  qualifier = data.aws_lambda_alias.latest.function_version
}

 data "aws_lambda_alias" "latest" {
  function_name = var.function_name
  name          = "dev"
} */

resource "aws_lambda_alias" "env_lambda_alias" {
  name             = terraform.workspace
  description      = "Release candidate - "
  function_name    = var.function_name
  function_version = terraform.workspace == "dev" ? "$LATEST" : aws_lambda_function.payload.version
}