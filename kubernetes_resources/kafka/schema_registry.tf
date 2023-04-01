resource "kubernetes_deployment" "schema_registry" {
  metadata {
    name      = "schema-registry"
    namespace = kubernetes_namespace.main.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "schema-registry"
      }
    }

    template {
      metadata {
        labels = {
          app = "schema-registry"
        }
      }

      spec {
        container {
          name  = "schema-registry"
          image = "confluentinc/cp-schema-registry:5.4.0"

          env {
            name  = "SCHEMA_REGISTRY_HOST_NAME"
            value = "schema-registry"
          }

          env {
            name  = "SCHEMA_REGISTRY_KAFKASTORE_CONNECTION_URL"
            value = "zookeeper:2181"
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "schema_registry" {
  metadata {
    name      = "schema-registry"
    namespace = kubernetes_namespace.main.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_deployment.schema_registry.spec[0].selector[0].match_labels.app
    }
    port {
      name        = "http"
      port        = 8081
      target_port = 8081
    }
    type = "ClusterIP"
  }
}