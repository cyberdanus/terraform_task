provider "aws" {
  region = "us-east-1"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49"
    }
  }
}
module "s3-default" {
  source = "./modules/aws_s3_create"
  }

module "s3-prod" {
  source = "./modules/aws_s3_create"
  env                  = "prod"
  s3_bucket_count             = "4"
}

module "s3-test" {
  source = "./modules/aws_s3_create"
  env                  = "staging"
  s3_bucket_count = "5"
}