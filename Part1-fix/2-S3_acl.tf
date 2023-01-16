resource "aws_s3_bucket_acl" "acl" {
  count  = 3
  bucket = aws_s3_bucket.my_bucket[count.index].id
  acl    = "private"
}