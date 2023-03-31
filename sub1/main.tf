provider "aws" {
  region = "us-west-2"
}

module "lambda" {
  source = "../modules/lambda"
    
  function_name = var.function_name
  handler       = var.lambda_handler
  runtime       = var.compatible_runtimes
  publish = true
}
