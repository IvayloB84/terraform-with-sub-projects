provider "aws" {
  region = "us-west-2"
}

module "lambda-layer" {
  source = "../modules/lambda/lambda-layers"

  function_name = "sub3-with-version"
  description   = "Lambda function + version"
}