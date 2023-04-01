resource "kubernetes_deployment" "kafka_tools" {
  metadata {
    name      = "kafka-tools"
    namespace = kubernetes_namespace.main.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "kafka-tools"
      }
    }
    template {
      metadata {
        labels = {
          app = "kafka-tools"
        }
      }
      spec {
        container {
          name  = "kafka-tools"
          image = "confluentinc/cp-kafka:5.4.0"

          command = [
            "tail",
            "-f",
            "/dev/null"
          ]
        }
      }
    }
  }
}