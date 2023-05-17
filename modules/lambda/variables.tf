
variable "create" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "create_function" {
  description = "Controls whether Lambda Function resource should be created"
  type        = bool
  default     = true
}

variable "create_layer" {
  description = "Controls whether Lambda Layer resource should be created"
  type        = bool
  default     = false
}

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
