  resource "helm_release" "pushgateway" {
  name       = "${var.namespace}-pushgateway"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-pushgateway"
  namespace  = var.namespace
  version    = "1.5.0"

  values = [templatefile("${path.module}/templates/pushgateway.yaml.tpl", {
    enable_service_monitor = var.enable_service_monitor
    namespace  = var.namespace
  })]
}
