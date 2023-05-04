# backend.hcl
bucket = "sprintray-tf-state-files"
region = "us-east-2"
dynamodb_table = "terraform-up-and-running-locks"
encrypt = true