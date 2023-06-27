locals {
  aws_s3_bucket = var.function_name
} 
 
 terraform {
   backend "s3" {
     # Bucket name, key tag and AZ
     bucket = "sprintray-tf-state-files"
     key    = "global/s3/${local.aws_s3_bucket}/terraform.tfstate"
     region = "us-west-2"
    
     # DybamoDB table name
     dynamodb_table = "sprintray-tf-state-files"
     encrypt        = true
   }
 }