variable "environment" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "bosh_vpc_cidr" {}
variable "az1" {}
# public subnet
variable "public_subnet_cidr_az1" {
    description = "CIDR for the Public Subnet 1"
    default = "10.3.0.0/24"
}
variable "my_public_ip_cidr" {}
variable "aws_key_name" {}

variable "concourse_private_subnet_cidr_az1" {
    description = "CIDR for the Private Subnet 1"
    default = "10.3.10.0/24"
}
