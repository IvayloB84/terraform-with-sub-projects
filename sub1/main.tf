provider "aws" {
  region = "us-west-2"
}

module "lambda" {
  source = "../modules/lambda"

  iam_role_name       = "tf-lambda-git-role"
  iam_policy_name     = "tf-lambda-policy-name"
  function_name       = "tf-lambda-sub1"
  lambda_handler      = "index.handler"
  compatible_runtimes = "nodejs14.x"
  dir                 = "sub1"
}
