provider "aws" {
  region = "us-west-2"
}

module "lambda" {
   source = "./modules"
}

locals {
   vpc_id = "${modules.my_vpc.vpc_id}"
}

module "lambda-layer" {
  source = "../modules/lambda/lambda-layer"

  layer_name =  "sub3-lambda-with-layer"
  function_name       = "tf-lambda-sub3"
  description         = "Lambda function + layer created with Terraform"
  }

  output "function_name" {
 value = "${modules.lambda.function_name}"  
}