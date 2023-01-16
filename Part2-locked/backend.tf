terraform {
  backend "s3" {
    encrypt = true    
    bucket = "2db-tf-bucket"
    dynamodb_table = "terraform-state-lock-dynamo"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
