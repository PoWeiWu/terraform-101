variable "region" {
  default = "asia-east1"
}

variable "vpc_name" {
  description = "VPC Name"
}

variable "subnet_name" {
  description = "Subnet Name"
}

variable "instance_name" {
  description = "GCE instance name"
}

variable "machine_type" {
  description = "gce machine type"
  default = "e2-medium"
}

variable "zone" {
  default = "asia-east1-a"
}

variable "image" {
  default = "rhel-cloud/rhel-7"
}