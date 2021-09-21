variable "project_id" {
  description = "GCP project ID"
  default     = "tf-lab-life"
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
  default     = "tf-subnet"
}

variable "subnet_cidr" {
  description = "subnet CIDR range"
  default     = "10.100.2.0/24"
}

variable "instance_name" {
  description = "GCE instance name"
  default     = "my-vm"
}

variable "machine_type" {
  description = "GCE machine type"
  default     = "e2-medium"
}

variable "instace_image" {
  description = "GCE image"
  default     = "rhel-cloud/rhel-7"
}