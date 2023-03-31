module "lambda" {
  source = "./modules/lambda"
  
  function_name = "${var.function_name}"
  iam_role_name = "${var.iam_role_name}"
  iam_policy_name = "${var.iam_policy_name}"
  lambda_handler       = "${var.lambda_handler}"
  compatible_runtimes       = "${var.compatible_runtimes}"
  publish = "${var.publish}"
}
