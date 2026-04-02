# Variables for DynamoDB
variable "name" {
  type        = string
  default     = "terraform-lock-table"
  description = "Name of the DB and it should be unique within a region name of the table"
}

variable "read_capacity" {
  type        = number
  default     = 5
  description = "Number of read units for this table. If the billing_mode is PROVISIONED, this field is required."
}

variable "write_capacity" {
  type        = number
  default     = 5
  description = "Number of write units for this table. If the billing_mode is PROVISIONED, this field is required."
}

variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST. Defaults to PROVISIONED."
}

variable "hash_key" {
  type        = string
  default     = "LockID"
  description = "Name of the hash key in the index; must be defined as an attribute in the resource."
}

variable "tagName" {
  type        = string
  default     = "IDT-TS-Vignemale"
  description = "Provide Tag Name here."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Provide environment here in tag section."
}