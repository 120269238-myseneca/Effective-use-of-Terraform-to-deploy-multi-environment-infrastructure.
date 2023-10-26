

variable "staging_vpc_cidr" {
   default     = "10.1.0.0/16"
  description = "The CIDR block for the staging VPC"
  type        = string
}

variable "prod_vpc_cidr" {
  default     = "10.10.0.0/16"
  description = "The CIDR block for the prod VPC"
  type        = string
}