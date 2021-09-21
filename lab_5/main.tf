provider "google" {
  credentials = file("../_credential/google.json")
  project     = "tf-lab-life"
}

provider "google-beta" {
  credentials = file("../_credential/google.json")
  project     = "tf-lab-life"
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "3.4.0"
  # insert the 3 required variables here

  network_name = "module-vpc"
  project_id   = "tf-lab-life"
  subnets = [{
    subnet_name   = "my-subnet-01"
    subnet_ip     = "10.10.10.0/24"
    subnet_region = "asia-east1"
  }]
}

module "my_vm" {
  source        = "./modules/gce"
  instance_name = "my-vm"
  zone          = "asia-east1-a"
  network       = module.network.network_id
  subnetwork    = module.network.subnets_ids[0]
}

