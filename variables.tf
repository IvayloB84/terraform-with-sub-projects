variable "function_name" {
  description = "The function ARN of the Lambda function for which you want to create an alias."
  type        = string
  default = ""
}

variable "compatible_runtimes" {
  description = "Default runtime for lambda"
  type = string
  default = ""
}

variable "iam_role_name" {
  description = "Default runtime for lambda"
  type = string
}

variable "iam_policy_name" {
  description = "Default runtime for lambda"
  type = string
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type = string 
}

variable "publish" {
  description = "Default publish role"
  type = bool
  default = true
}
