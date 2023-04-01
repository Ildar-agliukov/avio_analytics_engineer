resource "kubernetes_deployment" "zookeeper" {
  metadata {
    name      = "zookeeper"
    namespace = kubernetes_namespace.main.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "zookeeper"
      }
    }
    template {
      metadata {
        labels = {
          app = "zookeeper"
        }
      }
      spec {
        container {
          name  = "zookeeper"
          image = "confluentinc/cp-zookeeper:5.4.0"

          env {
            name  = "ZOOKEEPER_CLIENT_PORT"
            value = "2181"
          }
          env {
            name  = "ZOOKEEPER_TICK_TIME"
            value = "2000"
          }

          port {
            container_port = 2181
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "zookeeper" {
  metadata {
    name      = "zookeeper"
    namespace = kubernetes_namespace.main.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_deployment.zookeeper.spec[0].selector[0].match_labels.app
    }
    port {
      port        = 2181
      target_port = 2181
    }
  }
}