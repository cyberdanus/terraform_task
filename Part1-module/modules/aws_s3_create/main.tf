terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49"
    }
  }
}

resource "aws_s3_bucket" "my_bucket" {
  count  = var.s3_bucket_count
  bucket = "my-${count.index}-tf-bucket"

  tags = {
    Name = "My-${var.env}-${count.index}-bucket"
    Env = var.env
}
}
resource "aws_s3_bucket_acl" "acl" {
  count  = var.s3_bucket_count
  bucket = aws_s3_bucket.my_bucket[count.index].id
  acl    = "private"
}

