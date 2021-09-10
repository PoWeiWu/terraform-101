provider "google" {
  credentials = file("../_credential/google.json")
  project     = "tf-lab-life"
}

data "google_compute_image" "my_image" {
  family  = "rhel-7"
  project = "rhel-cloud"
}

#create gcp vpc network
resource "google_compute_network" "tf_vpc" {
  name                    = "tf-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

#create a subnetwork at asia-east1 and base on tf-vpc
resource "google_compute_subnetwork" "tf_subnet" {
  name          = "tf-subnet"
  ip_cidr_range = "10.10.1.0/24"
  region        = "asia-east1"
  network       = google_compute_network.tf_vpc.name

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

#create a gce vm
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
    network    = google_compute_network.tf_vpc.id
    subnetwork = google_compute_subnetwork.tf_subnet.id

    access_config {
      // Ephemeral public IP
    }
  }

}

output "public_ip" {
  value = google_compute_instance.gce.network_interface[0].access_config[0].nat_ip
}