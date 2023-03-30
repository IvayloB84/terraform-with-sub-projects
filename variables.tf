variable "description" {
  description = "Description of the lambda."
  type        = string
  default = "Descriptions"
}

variable "function_name" {
  description = "The function ARN of the Lambda function for which you want to create an alias."
  type        = string
  default     = "tf-lambda-git"
}

variable "compatible_runtimes" {
  description = "Default runtime for lambda"
  type = string
  default = "nodejs14.x"
}

variable "iam_role_name" {
  description = "Default runtime for lambda"
  type = string
  default = "task_payload"
}

variable "iam_policy_name" {
  description = "Default runtime for lambda"
  type = string
  default = "AWSLambdaBasicExecutionRole-f81c3014-0f09"
}

variable "lambda_handler" {
  description = " Lambda function handler"
  type = string
  default = "index_handler"
}
