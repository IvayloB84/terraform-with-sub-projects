variable "description" {
  description = "Description of the alias."
  type        = string
}

variable "function_name" {
  description = "The function ARN of the Lambda function for which you want to create an alias."
  type        = string
}

variable "function_version" {
  description = "Lambda function version for which you are creating the alias. Pattern: ($LATEST|[0-9]+)."
  type        = string
}

variable "compatible_runtimes" {
  description = "Default runtime for lambda"
  type = string
  default = "nodejs14.x"
}

variable "iam_role_name" {
  description = "Default runtime for lambda"
  type = string
}

variable "iam_policy_name" {
  description = "Default runtime for lambda"
  type = string
}

variable = "lambda_handler" {
  descriptions = "Lambda function handler"
  type = string 
}
