

output "data_aws_subnets" {
  value = data.aws_subnets.print.ids
}
output "data_aws_security_groups" {
  value = data.aws_security_groups.print.ids
}