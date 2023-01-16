resource "aws_s3_bucket" "my_bucket" {
  count  = 3
  bucket = "my-${count.index}-tf-bucket"

  tags = {
    Name = "My ${count.index} bucket"
  }
}