variable "region" {
  default = "eu-north-1"
}

# Variables for DB

variable "db_username" {}
variable "db_password" {}

# Variables for app

variable "mediawiki_major_version" {}
variable "mediawiki_minor_version" {}

# Variables for VPC

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "mediawikiVpc"
}

variable "subnets_cidr_public" {
  type    = list(any)
  default = ["10.0.1.0/24"]
}

variable "azs_public" {
  type    = list(any)
  default = ["eu-north-1a"]
}

# Variables for EC2

variable "instance_ami" {
  default = "ami-0a6351192ce04d50c"
}
variable "instance_type" {
  default = "t3.micro"
}

variable "keyname" {
  default = "awskey"
}
