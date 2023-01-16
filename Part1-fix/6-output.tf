output "bucket_id" {
  value = join(":", aws_s3_bucket.my_bucket.*.id)
}
output "bucket_acl" {
  value = join(":", aws_s3_bucket_acl.acl.*.id)
}

output "data_aws_vpcs" {
  value = data.aws_vpcs.print.ids
}
output "data_aws_subnets" {
  value = data.aws_subnets.print.ids
}
output "data_aws_security_groups" {
  value = data.aws_security_groups.print.ids
}