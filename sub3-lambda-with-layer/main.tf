provider "aws" {
  region = "us-west-2"
}

module "lambda-layer" {
  source = "../modules/lambda/lambda-layer"

  layer =  "sub3-lambda-with-layer"
  function_name       = "tf-lambda-sub3"
  description         = "Lambda function + layer created with Terraform"
  }

  output "function_name" {
 value = "${modules.lambda.function_name}"  
}