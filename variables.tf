variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "tfstate_bucket" {
  type = string
}

variable "lock_table" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"] # hardcoded instead of interpolation
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "bastion_ip" {
  type        = string
  description = "Your workstation IP in CIDR form (e.g. 1.2.3.4/32)"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "asg_min" {
  type    = number
  default = 1
}

variable "asg_max" {
  type    = number
  default = 3
}

variable "asg_desired" {
  type    = number
  default = 1
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "appuser"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "ecr_repo" {
  type        = string
  description = "ECR repository URI (account-id.dkr.ecr.region.amazonaws.com/repo)"
}

variable "app_image_tag" {
  type    = string
  default = "latest"
}
