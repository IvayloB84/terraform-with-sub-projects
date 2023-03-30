module "lambdas" {
  source = "../modules/lambda"
    
  function_name = var.function_name
  handler       = "index.lambda_handler"
  runtime       = var.compatible_runtimes
}
