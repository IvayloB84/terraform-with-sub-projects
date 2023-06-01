provider "aws" {
  region = "us-west-2"
}

data "aws_caller_identity" "current" {}

locals {
  lambda_src_path = "./lambda"
}

resource "aws_sns_topic" "user_updates" {
  name = "tf-sns-topic"
}

resource "aws_lambda_event_source_mapping" "tf-source" {
  event_source_arn  = aws_sns_topic.user_updates.arn
  function_name     = aws_lambda_function.TF-if-else-statement.arn
  starting_position = "LATEST"
}

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

resource "aws_lambda_function" "TF-if-else-statement" {
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

resource "aws_lambda_event_source_mapping" "source_mapping" {
  event_source_arn  = aws_sns_topic.user_updates.arn
  function_name     = aws_lambda_function.TF-if-else-statement.arn
  starting_position = "LATEST"
}
