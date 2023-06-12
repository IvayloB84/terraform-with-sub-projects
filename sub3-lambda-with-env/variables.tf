variable "create" {
  type = bool
  default = true
}

variable "function_name" {
  type = string
  default = "sub3-with-env"  
}

variable "description" {
  type = string
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
  type = string 
  default = "sub3-with-env-role"
}

variable "iam_policy_name" {
  type = string 
  default = "sub3-with-env-with-policy"
} 

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default = "index.handler"
}


 variable "env_names" {
   type = list(string)

   default = [
    {
      staging = "staging"
     development = "dev"
     production = "prod"
   }
   ]
 }