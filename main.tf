data "google_client_config" "default" {}

provider "google" {
  project = "metal-apricot-381918"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_container_cluster" "gke_cluster" {
  name     = "kafka-gke-cluster"
  location = "us-central1-a"

  node_pool {
    name       = "default-pool"
    node_count = 3

    node_config {
      preemptible  = false
      machine_type = "n1-standard-2"

      metadata = {
        disable-legacy-endpoints = "true"
      }

      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }
}

output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate
}

provider "kubernetes" {
  host                   = google_container_cluster.gke_cluster.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate)
}

module "kubernetes_resources" {
  source = "./kubernetes_resources"
}