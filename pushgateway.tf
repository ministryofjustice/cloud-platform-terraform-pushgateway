

resource "helm_release" "pushgateway" {
  name       = "pushgateway"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "prometheus-pushgateway"
  namespace  = var.namespace
  version    = "1.4.2"

  values = [templatefile("${path.module}/templates/pushgateway.yaml.tpl", {
    enable_service_monitor = var.enable_service_monitor
  })]
}