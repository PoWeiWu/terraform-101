data "google_compute_image" "my_image" {
  family  = "rhel-7"
  project = "rhel-cloud"
}

#create gcp vpc network
resource "google_compute_network" "tf_vpc" {
  name                    = var.vpc_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

#create a subnetwork at asia-east1 and base on tf-vpc
resource "google_compute_subnetwork" "tf_subnet" {
  name          = var.subnet_id
  ip_cidr_range = "10.10.1.0/24"
  region        = var.region
  network       = google_compute_network.tf_vpc.name

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "ping" {
  name    = "ping"
  network = google_compute_network.tf_vpc.id

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = google_compute_network.tf_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "web" {
  name    = "web-access"
  network = google_compute_network.tf_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

#create a gce vm
resource "google_compute_instance" "gce" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = "asia-east1-a"

  boot_disk {
    initialize_params {
      image = var.instace_image
    }
  }
  network_interface {

    network    = google_compute_network.tf_vpc.id
    subnetwork = google_compute_subnetwork.tf_subnet.id

    access_config {
      // Ephemeral public IP
    }
  }

  tags = ["ssh", "web"]

  depends_on = [
    google_compute_firewall.ssh
  ]

  metadata = {
    ssh-keys = "paul_wu:${file("~/.ssh/id_rsa.pub")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd",
      "sudo systemctl start httpd && sudo systemctl enable httpd",
      "echo '<h1><center>This is remote-exec Demo Web</center></h1>' > index.html",
      "sudo mv index.html /var/www/html/",
      "sudo setenforce 0",
      "sudo chmod -R 755 /var/www/html/"
    ]

    connection {
      type        = "ssh"
      user        = "paul_wu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }
}