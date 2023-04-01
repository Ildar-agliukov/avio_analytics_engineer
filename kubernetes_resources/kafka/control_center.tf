resource "kubernetes_deployment" "control_center" {
  metadata {
    name      = "control-center"
    namespace = kubernetes_namespace.main.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "control-center"
      }
    }
    template {
      metadata {
        labels = {
          app = "control-center"
        }
      }
      spec {
        container {
          name  = "control-center"
          image = "confluentinc/cp-enterprise-control-center:5.4.0"

          env {
            name  = "CONTROL_CENTER_BOOTSTRAP_SERVERS"
            value = "broker:29092"
          }
          env {
            name  = "CONTROL_CENTER_ZOOKEEPER_CONNECT"
            value = "zookeeper:2181"
          }
          env {
            name  = "CONTROL_CENTER_SCHEMA_REGISTRY_URL"
            value = "http://schema-registry:8081"
          }
          env {
            name  = "CONTROL_CENTER_REPLICATION_FACTOR"
            value = "1"
          }
          env {
            name  = "CONTROL_CENTER_INTERNAL_TOPICS_PARTITIONS"
            value = "1"
          }
          env {
            name  = "CONTROL_CENTER_MONITORING_INTERCEPTOR_TOPIC_PARTITIONS"
            value = "1"
          }
          env {
            name  = "CONFLUENT_METRICS_TOPIC_REPLICATION"
            value = "1"
          }
          env {
            name  = "PORT"
            value = "9021"
          }
          # Add the rest of the environment variables

        }
      }
    }
  }
}


resource "kubernetes_service" "control_center" {
  metadata {
    name      = "control-center"
    namespace = kubernetes_namespace.main.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_deployment.control_center.spec[0].selector[0].match_labels.app
    }
    port {
      port        = 9021
      target_port = 9021
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = kubernetes_service.control_center.status.0.load_balancer.0.ingress.0.ip
}