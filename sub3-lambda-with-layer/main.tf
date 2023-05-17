provider "aws" {
  region = "us-west-2"
}

resource "time_sleep" "wait_20_seconds" {
  depends_on = [
    null_resource.archive
  ]

  create_duration = "20s"
}

module "lambda-layer" {
  source = "../modules/lambda/lambda-layers"

  layer_name =  "sub3-lambda-with-layer"
  function_name       = "tf-lambda-sub3"
  description         = "Lambda function + layer created with Terraform"

  depends_on = [ 
    time_sleep.wait_20_seconds 
    ]
  }