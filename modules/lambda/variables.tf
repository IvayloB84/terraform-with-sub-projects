variable "function_name" {
  description = "The function ARN of the Lambda function for which you want to create an alias."
  type        = string
}

variable "description" {
  description = "The function ARN of the Lambda function for which you want to create an alias."
  type        = string
  default     = ""
}

variable "compatible_runtimes" {
  description = "Default runtime for lambda"
  type        = string
}

variable "iam_role_name" {
  description = "Default runtime for lambda"
  type        = string
}

variable "iam_policy_name" {
  description = "Default runtime for lambda"
  type        = string
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
}

variable "layer_name" {
  description = "Layer for Lambda function"
  type        = string
  default     = ""
}

variable "dir" {
  description = "Lambda variable for Lambda function directory"
  type        = string
}
