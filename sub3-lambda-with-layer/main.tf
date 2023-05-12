provider "aws" {
  region = "us-west-2"
}

module "lambda-layer" {
  source = "../modules/lambda/lambda-layer"

  # iam_role_name       = "tf-lambda-iam-role-sub3"
  # iam_policy_name     = "tf-lambda-policy-sub3"
  # function_name       = "tf-lambda-sub3"
  # description         = "Lambda function + layer created with Terraform"
  # lambda_handler      = "index.handler"
  layer_name          = "sub3-lambda-with-layer"
  # compatible_runtimes = "nodejs14.x"
  # dir                 = "sub3-lambda-with-layer"
  }