variable "function_name" {
  description = "The function ARN of the Lambda function for which you want to create an alias."
  type        = string
  default     = "Imported_function"
}

variable "description" {
  description = "Layer for Lambda function"
  type        = string
  default     = "Terraform imported lambda with event source mapping"
}

variable "compatible_runtimes" {
  description = "Default runtime for lambda"
  type        = string
  default     = "nodejs14.x"
}

variable "iam_role_name" {
  description = "Default runtime for lambda"
  type        = string
  default     = "most-new-tf-iam-role"
}

variable "iam_policy_name" {
  description = "Default runtime for lambda"
  type        = string
  default     = "most-new-tf-iam-policy-name"
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "index.handler"
}