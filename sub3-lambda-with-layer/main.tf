provider "aws" {
  region = "us-west-2"
}


module "lambda-layer" {
  source = "../modules/lambda/lambda-layers"

  layer_name =  "sub3-lambda-with-layer"
  function_name       = "tf-lambda-sub3"
  description         = "Lambda function + layer created with Terraform"

  create_layer = true

  depends_on = [ 
    time_sleep.wait_20_seconds 
    ]
  }