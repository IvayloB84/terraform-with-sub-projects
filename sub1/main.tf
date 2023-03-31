provider "aws" {
  region = "us-west-2"
}

module "lambda" {
  source = "../modules/lambda"
    
  function_name = "tf-lambda-git"
  lambda_handler       = "index_handler"
  compatible_runtimes       = "nodejs14.x"
  publish = true
}
