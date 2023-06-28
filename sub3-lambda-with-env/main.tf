provider "aws" {
  region = "us-west-2"
}

locals {
  lambda_src_path = "./lambda"
  create          = var.create

  /*   layer_src_path  = "./source"
  destination_dir = "${path.module}./layers/${var.layer_name}" */
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

resource "aws_lambda_function" "payload" {

  function_name = "${var.function_name}"
  filename      = data.archive_file.payload_zip.output_path
  description   = var.description
  role          = aws_iam_role.payload.arn
  handler       = var.lambda_handler
  runtime       = var.compatible_runtimes
  timeout       = 90

  source_code_hash = data.archive_file.payload_zip.output_base64sha256
  publish          = true

    depends_on = [
    aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role,
    data.archive_file.payload_zip,
    null_resource.archive
  ]
}

resource "aws_lambda_alias" "env_lambda_alias" {
  name             = "${terraform.workspace}"
  description      = "Release candidate - "
  function_name    = var.function_name
  function_version = "${terraform.workspace}" == "dev" ? "$LATEST" : "${aws_lambda_function.payload.version}"
}