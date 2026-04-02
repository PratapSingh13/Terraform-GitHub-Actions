# # terraform/backend.tf
# terraform {
#   backend "s3" {
#     bucket         = "nagarro-promotion"
#     key            = "environment/${terraform.workspace}/nagarro-promotion.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "terraform-lock-table"
#   }
# }
