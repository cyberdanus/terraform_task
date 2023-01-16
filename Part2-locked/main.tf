provider "aws" {
  region  = "us-east-1"
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
  source = "./modules/aws_instance"
  }

module "s3-prod" {
  source = "./modules/aws_network"
}

module "s3-test" {
  source = "./modules/aws_sg"
}