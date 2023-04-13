provider "aws" {
  region = "us-west-2"    
}

module "lambda" {
  source = "../modules/lambda"
  
  iam_role_name = "tf-lambda-sub3"
  iam_policy_name = "tf-lambda-policy-sub3"
  function_name = "tf-lambda-sub3"      
  lambda_handler   = "index.handler"
  compatible_runtimes  = "nodejs14.x
}
