provider "google" {
  credentials = file("../_credential/google.json")
  project     = "tf-lab-life"
}

# #create a gce vm
# resource "google_compute_instance" "gce" {
#   name         = "my-vm"
#   machine_type = "e2-medium"
#   zone         = "asia-east1-a"

#   boot_disk {
#     initialize_params {
#       image = "rhel-cloud/rhel-7"
#       # image = data.google_compute_image.my_image.self_link
#     }
#   }
#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral public IP
#     }
#   }
# }