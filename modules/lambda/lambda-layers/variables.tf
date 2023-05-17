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
  description = "Name of Lambda function to create/update"
  type        = string
  default     = ""
}

variable "description" {
  description = "Lambda layer description"
  type        = string
  default     = ""
}