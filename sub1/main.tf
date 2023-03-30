module "lambda" {
  source = "../modules/lambda"
    
  function_name = var.function_name
  handler       = "index.lambda_handler"
  runtime       = var.compatible_runtimes
  publish = true
  
  source_path = "./sub1"
}
