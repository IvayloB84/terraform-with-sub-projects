provider "aws" {
  region = "us-west-2"
}

module "lambda-layer" {
  source = "../modules/lambda/lambda-layer"

  # function_name       = "tf-lambda-sub3"
  description         = "Lambda function + layer created with Terraform"
  layer_name          = "sub3-lambda-with-layer"
  }