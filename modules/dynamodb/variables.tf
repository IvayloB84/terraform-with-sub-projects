variable "create_table" {
  description = "Controls if DynamoDB table and associated resources are created"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = null
}

variable "billing_mode" {
  description = "Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "Number of read units for this table.  If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "Number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = null
}

variable "hash_key" {
  description = "Number of write units for this table"
  type        = string
  default     = null
}

variable "range_key" {
  description = "Attribute to use as the range (sort) key."
  type        = string
  default     = ""
}

variable "attribute_name" {
  description = "The name of the table attribute to store the TTL timestamp in."
  type        = string
  default     = ""
}

variable "ttl_enabled" {
  description = "Configuration block for TTL. Number of write units for this table. If the billing_mode is PROVISIONED, this field is required."
  type        = bool
  default     = false
}

variable "global_secondary_indexes" {
  description = "Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc."
  type        = any
  default     = []
}