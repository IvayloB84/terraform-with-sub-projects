provider "aws" {
  region = "us-west-2"
}

module "lambda" {
  source = "../modules/lambda"
  
  iam_role_name = "tf-lambda-git-role"
  iam_policy_name = "tf-lambda-policy-name"
  function_name = "tf-lambda-git"
  lambda_handler       = "index.handler"
  compatible_runtimes       = "nodejs14.x"
  source_code_hash = data.archive_file.payload_zip.output_base64sha256
  
  ignore_source_code_hash = false
  publish = true
}
