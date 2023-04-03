provider "aws" {
  region = "us-west-2"
}

module "lambda" {
  source = "./modules/lambda"
    
  iam_role_name = var.iam_role_name
  iam_policy_name = var.iam_policy_name
  function_name = iam_function_name
  lambda_handler       = var.lambda_handler
  compatible_runtimes       = var.compatible_runtimes
  
  publish = true
}
