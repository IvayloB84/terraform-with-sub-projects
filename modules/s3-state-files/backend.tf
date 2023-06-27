# terraform {
#   backend "s3" {
#     # Bucket name, key tag and AZ
#     bucket = "sprintray-tf-state-files"
#     key    = "global/s3/terraform.tfstate"
#     region = "us-west-2"
    
#     # DybamoDB table name
#     dynamodb_table = "sprintray-tf-state-files"
#     encrypt        = true
#   }
# }