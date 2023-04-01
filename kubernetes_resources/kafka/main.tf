resource "kubernetes_namespace" "main" {
  metadata {
    name = "example-namespace"
  }
}
