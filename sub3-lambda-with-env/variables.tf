variable "create" {
  type    = bool
  default = true
}

variable "use_existing_alias" {
  description = "Whether to manage existing alias instead of creating a new one. Useful when using this module together with external tool do deployments (eg, AWS CodeDeploy)."
  type        = bool
  default     = false
}

variable "refresh_alias" {
  description = "Whether to refresh function version used in the alias. Useful when using this module together with external tool do deployments (eg, AWS CodeDeploy)."
  type        = bool
  default     = true
}

variable "function_name" {
  type    = string
  default = "sub3-with-aliases"
}

variable "function_version" {
  description = "Lambda function version for which you are creating the alias. Pattern: ($LATEST|[0-9]+)."
  type        = string
  default     = ""
}

variable "description" {
  type    = string
  default = "Lambda function + environment"
}

variable "compatible_runtimes" {
  description = "Lambda Function runtime"
  type        = string
  default     = "nodejs14.x"
}

/* variable "layer_name" {
  type = string
  default =
} */

variable "iam_role_name" {
  type    = string
  default = "sub3-with-env-role"
}

variable "iam_policy_name" {
  type    = string
  default = "sub3-with-env-with-policy"
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "index.handler"
}
