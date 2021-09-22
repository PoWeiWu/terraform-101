provider "google" {
  credentials = file("../_credential/google.json")
  project     = "tf-lab-life"
}

variable "region" {
  description = "resource region"
  default     = "asia-east1"
}

data "google_compute_image" "my_image" {
  family  = "rhel-7"
  project = "rhel-cloud"
}

#create gcp vpc network
resource "google_compute_network" "vpc" {
  name                    = "my-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

#create a subnetwork at asia-east1 and base on tf-vpc
resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.10.1.0/24"
  # region        = "asia-east1"
  region  = var.region
  network = google_compute_network.vpc.name

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "ping" {
  name    = "ping"
  network = google_compute_network.vpc.id

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "web" {
  name    = "allow-web"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

# #create a gce vm
resource "google_compute_instance" "gce" {
  name         = "my-vm"
  machine_type = "e2-medium"
  zone         = "asia-east1-a"

  boot_disk {
    initialize_params {
      # image = "rhel-cloud/rhel-7"
      image = data.google_compute_image.my_image.self_link
    }
  }
  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      // Ephemeral public IP
    }
  }
  # 強制相依性
  # depends_on = [
  #   google_compute_subnetwork.subnet.id
  # ]

  tags = ["ssh", "web"]
}

output "vpc_name" {
  description = "vpc ID"
  value       = google_compute_network.vpc.id
}

output "public_ip" {
  description = "GCE pubic IP"
  value       = google_compute_instance.gce.network_interface[0].access_config[0].nat_ip
}