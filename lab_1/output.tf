output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "public_ip" {
  value = google_compute_instance.gce.network_interface[0].access_config[0].nat_ip
}