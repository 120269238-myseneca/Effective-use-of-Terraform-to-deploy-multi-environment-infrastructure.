terraform {
  backend "s3" {
    bucket = "acs730-assignment-ssaurabh3"         // Bucket where to SAVE Terraform State
    key    = "staging-webservers/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                        // Region where bucket is created
  }
}