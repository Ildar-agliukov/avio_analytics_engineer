resource "kubernetes_deployment" "broker" {

  metadata {
    name      = "broker"
    namespace = kubernetes_namespace.main.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "broker"
      }
    }
    template {
      metadata {
        labels = {
          app = "broker"
        }
      }
      spec {
        container {
          name  = "broker"
          image = "confluentinc/cp-server:5.4.0"

          env {
            name  = "KAFKA_BROKER_ID"
            value = "1"
          }
          env {
            name  = "KAFKA_ZOOKEEPER_CONNECT"
            value = "zookeeper:2181"
          }
          env {
            name  = "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP"
            value = "PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT"
          }
          env {
            name  = "KAFKA_ADVERTISED_LISTENERS"
            value = "PLAINTEXT://broker:29092,PLAINTEXT_HOST://${kubernetes_service.broker.status.0.load_balancer.0.ingress.0.ip}:9092"
          }
          env {
            name  = "KAFKA_METRIC_REPORTERS"
            value = "io.confluent.metrics.reporter.ConfluentMetricsReporter"
          }
          env {
            name  = "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR"
            value = "1"
          }
          env {
            name  = "KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS"
            value = "0"
          }
          env {
            name  = "KAFKA_CONFLUENT_LICENSE_TOPIC_REPLICATION_FACTOR"
            value = "1"
          }
          env {
            name  = "CONFLUENT_METRICS_REPORTER_BOOTSTRAP_SERVERS"
            value = "broker:29092"
          }
          env {
            name  = "CONFLUENT_METRICS_REPORTER_ZOOKEEPER_CONNECT"
            value = "zookeeper:2181"
          }
          env {
            name  = "CONFLUENT_METRICS_REPORTER_TOPIC_REPLICAS"
            value = "1"
          }
          env {
            name  = "CONFLUENT_METRICS_ENABLE"
            value = "true"
          }
          env {
            name  = "CONFLUENT_SUPPORT_CUSTOMER_ID"
            value = "anonymous"
          }

          port {
            container_port = 9092
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "broker" {
  metadata {
    name      = "broker"
    namespace = kubernetes_namespace.main.metadata[0].name
  }
  spec {
    selector = {
      app = "broker"
    }
    port {
      name       = "broker-internal"
      port       = 29092
      target_port = 29092
    }
    port {
      name       = "broker-external"
      port       = 9092
      target_port = 9092
    }

    type = "LoadBalancer"
  }
}

output "broker_ip" {
  value = kubernetes_service.broker.status.0.load_balancer.0.ingress.0.ip
}