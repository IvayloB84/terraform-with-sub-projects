provider "aws" {
  region = "us-west-2"
}

module "lambda" {
  source = "../modules/lambda"

locals {
  layer_name = "${modules.lambda.lambda-layers.layer_name}"
}

}

module "lambda-layer" {
  source = "../modules/lambda/lambda-layer"

  layer_name          = "sub3-lambda-with-layer"
  function_name       = "tf-lambda-sub3"
  description         = "Lambda function + layer created with Terraform"
  }