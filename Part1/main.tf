terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
resource "aws_s3_bucket" "my_bucket" {
  count = 3
  bucket = "my-${count.index}-tf-bucket"

  tags = {
    Name        = "My ${count.index} bucket"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  count = 3
  bucket = aws_s3_bucket.my_bucket[count.index].id
  acl    = "private"
}

#data "aws_s3_bucket_objects" "print" {
#  count = 3
#  bucket = aws_s3_bucket.my_bucket[count.index]
#}
#data "aws_s3_bucket_policy" "print"{
#  bucket = "my_bucket"
#}
data "aws_subnets" "print" {}
data "aws_security_groups" "print" {}

#output "data_aws_s3_bucket_objects" {
#  value = data.aws_s3_bucket_objects
#output "data_aws_s3_bucket_policy" {
#  value = data.aws_s3_bucket_policy.print
#}
#output "data_aws_subnets" {
#  value = data.aws_subnets.print.ids
#}
#output "data_aws_security_groups" {
#  value = data.aws_security_groups.print.ids
#}
