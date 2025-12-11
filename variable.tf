variable "region" {
  default = "us-west-1"
}
variable "az1" {
  default = "us-west-1a"
}
variable "az2" {
  default = "us-west-1b"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "private_cidr" {
  default = "10.0.0.0/20"
}
variable "public_cidr" {
  default = "10.0.16.0/20"
}
variable "project_name" {
  default = "FCT"
}
variable "igw_cidr" {
 default = "0.0.0.0/0" 
}
variable "ami" {
  default = "ami-0e6a50b0059fd2cc3"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key" {
  default = "terraform"
}