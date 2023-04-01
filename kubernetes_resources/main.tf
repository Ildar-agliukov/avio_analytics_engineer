# resource "kubernetes_namespace" "main" {
#   metadata {
#     name = "example-namespace"
#   }
# }

module "kafka" {
  source = "./kafka"
}


# output "lb_ip" {
#   value = kubernetes_service.control_center.status.0.load_balancer.0.ingress.0.ip
# }