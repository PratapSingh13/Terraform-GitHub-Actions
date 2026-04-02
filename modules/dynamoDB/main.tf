# -----------------------------------------
# DynamoDB creation to make state file lock
# -----------------------------------------
resource "aws_dynamodb_table" "dynamoDB" {
  name = var.name
  # read_capacity  = var.read_capacity
  # write_capacity = var.write_capacity
  billing_mode = var.billing_mode
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = var.tagName
    Environment = var.environment
  }
}