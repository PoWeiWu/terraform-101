provider "google" {
  credentials = file("../../_credential/google.json")
  project     = var.project_id
}