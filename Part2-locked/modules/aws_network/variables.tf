variable "bastion" {
  default = "bastion"
}
variable "public" {
  default = "public"
}
variable "private" {
  default = "private"
}
variable "database" {
  default = "database"
}
variable "vpc_id" {
  default = "aws_vpc.main.id"
}
variable "az" {
  default = "us-east-1a"
}
