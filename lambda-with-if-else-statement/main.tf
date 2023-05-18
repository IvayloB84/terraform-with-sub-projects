data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-west-2"
}

locals {
  lambda_src_path = "./lambda"
  create          = var.create

  layer_src_path  = "./source"
//  destination_dir = "./layers/${var.function_name}"
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
  policy_arn = "${aws_iam_policy.AWSLambdaBasicExecutionRole}.arn"
}

resource "null_resource" "archive" {

  triggers = {
    dependencies_versions = filemd5("./index.js")
    create_file           = fileexists("./readme.txt")
    updated_at            = timestamp()

  }

  provisioner "local-exec" {

    command     = "mkdir -p ./lambda/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip','source/'} ./ ./lambda/ && cd ./lambda && npm install --legacy-peer-deps"
    interpreter = ["/bin/bash", "-c"]
  }
}

data "archive_file" "payload_zip" {
  type        = "zip"
  source_dir  = local.lambda_src_path
  output_path = "${path.module}/payload/${var.function_name}-payload.zip"
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

resource "null_resource" "layer_dependencies" {
  provisioner "local-exec" {
    command     = "mkdir -p ./source/nodejs/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip','source/'} ./ ./source/nodejs/ && cd ./source/nodejs/ && npm install --legacy-peer-deps && cd -"
    interpreter = ["/bin/bash", "-c"]
  }
}

data "archive_file" "local_layer" {
  type        = "zip"
  source_dir  = local.layer_src_path
  output_path = "${path.module}/layers/${var.layer_name}-layer.zip"
  depends_on = [
    null_resource.layer_dependencies
  ]
}

resource "time_sleep" "wait_20_seconds" {
  depends_on = [
    null_resource.archive
  ]

  create_duration = "20s"
}

resource "aws_lambda_function" "payload" {
  count = local.create && var.create_function && !var.create_layer ? 1 : 0

  function_name = var.function_name
  filename      = data.archive_file.payload_zip.output_path
  description   = var.description
  role          = aws_iam_role.payload.arn
  layers        = [
    aws_lambda_layer_version.lambda_layers[0].arn,
  ]
  handler       = var.lambda_handler
  runtime       = var.compatible_runtimes
  timeout       = 90

  depends_on = [
    aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role,
    data.archive_file.payload_zip,
    null_resource.layer_dependencies
  ]

  source_code_hash = data.archive_file.payload_zip.output_base64sha256
  publish          = true
}

resource "aws_lambda_layer_version" "lambda_layers" {
  count = local.create && var.create_layer ? 1 : 0

  filename            = "${path.module}/layers/${var.layer_name}-layer.zip"
  layer_name          = var.layer_name
  source_code_hash    = filebase64sha256("${path.module}/layers/${var.layer_name}-layer.zip")
  compatible_runtimes = ["nodejs14.x", "nodejs16.x"]

  depends_on = [
    data.archive_file.local_layer,
    null_resource.layer_dependencies
  ]
}