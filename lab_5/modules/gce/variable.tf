variable "project_id" {
  description = "GCP project ID"
}

variable "zone" {
  description = "GCE zone"
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

variable "network" {
  description = "The VPC where gce created."
}

variable "subnetwork" {
  description = "The subnetwork where gce created."
}

