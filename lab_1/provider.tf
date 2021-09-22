provider "google" {
  credentials = file("../_credential/google.json")
  project     = "tf-lab-life"
}