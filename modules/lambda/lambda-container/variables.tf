variable "function_name" {
  description = "Default function name for Lambda image"
  type        = string
}

variable "iam_role" {
  description = "Default IAM policy for Lambda image"
  type        = string
}

variable "iam_policy" {
  description = "Default IAM policy name for Lambda image"
  type        = string
}
