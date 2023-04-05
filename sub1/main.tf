provider "aws" {
  region = "us-west-2"
}

data "archive_file" "payload_zip" { }

module "lambda" {
  source = "../modules/lambda"
  
  iam_role_name = "tf-lambda-git-role"
  iam_policy_name = "tf-lambda-policy-name"
  function_name = "tf-lambda-git"
  lambda_handler       = "index.handler"
  compatible_runtimes       = "nodejs14.x"
  source_code_hash = data.archive_file.payload_zip.output_base64sha256
  publish = true
}
