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

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
  default     = null
}

variable "create_layer" {
  description = "Controls whether Lambda Layer resource should be created"
  type        = bool
  default     = false
}

variable "function_name" {
  description = "The function ARN of the Lambda function for which you want to create an alias."
  type        = string
  default     = "TF-if-else-statement"
}

variable "description" {
  description = "The function ARN of the Lambda function for which you want to create an alias."
  type        = string
  default     = "If else statement test"
}

variable "compatible_runtimes" {
  description = "Default runtime for lambda"
  type        = string
  default     = "nodejs14.x"
}

variable "iam_role_name" {
  description = "Default runtime for lambda"
  type        = string
  default     = "some-new-tf-iam-role"
}

variable "iam_policy_name" {
  description = "Default runtime for lambda"
  type        = string
  default     = "some-new-tf-iam-policy-name"
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "index.handler"
}

variable "layer_name" {
  description = "Layer for Lambda function"
  type        = string
  default     = "layer"
}