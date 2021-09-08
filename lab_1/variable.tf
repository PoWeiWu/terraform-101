variable "project_id" {
  description = "GCP project ID"
  default     = "premvc-20210523"
}

variable "region" {
  description = "Network region"
  default     = "asia-east1"
}

variable "vpc_id" {
  description = "This is VPC name"
  default     = "tf-vpc"
}

variable "subnet_id" {
  description = "This is subnet name"
  default     = "tf-vpc"
}

variable "subnet_cidr" {
  description = "subnet CIDR range"
}

variable "instance_name" {
  description = "GCE instance name"
}

variable "machine_type" {
  description = "GCE machine type"
  default     = "e2-medium"
}

variable "instace_image" {
  description = "GCE image"
  default     = "debian-cloud/debian-9"
}