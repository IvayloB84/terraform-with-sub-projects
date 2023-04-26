provider "aws" {
  region = "us-west-2"

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

module "lambda" {
  source = "../modules/lambda"

  iam_role_name       = "tf-lambda-iam-role-sub7"
  iam_policy_name     = "tf-lambda-policy-sub7"
  function_name       = "tf-lambda-sub7"
  lambda_handler      = "index.handler"
  compatible_runtimes = "nodejs14.x"
  dir                 = "sub7"
}

