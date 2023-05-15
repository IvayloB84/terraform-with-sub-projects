variable "layer_name" {
  description = "Name of Lambda Layer to create/update"
  type        = string
  default     = ""
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