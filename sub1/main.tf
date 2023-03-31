provider "aws" {
  region = "us-west-2"
}

module "lambda" {
  source = "../modules/lambda"
    
  function_name = "tf-lambda-git"
  handler       = "index_handler"
  runtime       = "nodejs14.x"
  publish = true
}
