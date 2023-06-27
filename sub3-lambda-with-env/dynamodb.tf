resource "aws_dynamodb_table" "state_locking" {
  hash_key = "LockID"
  name     = "dynamodb-terraform-state-locking"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}