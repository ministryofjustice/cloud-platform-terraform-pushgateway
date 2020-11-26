data "helm_repository" "pushgateway" {
  name = "prometheus-community"
  url  = "https://prometheus-community.github.io/helm-charts"
}

resource "helm_release" "pushgateway" {
  name       = "${var.namespace}-pushgateway"
  repository = data.helm_repository.pushgateway.metadata[0].name
  chart      = "prometheus-pushgateway"
  namespace  = var.namespace
  version    = "1.5.0"

  values = [templatefile("${path.module}/templates/pushgateway.yaml.tpl", {
    enable_service_monitor = var.enable_service_monitor
    namespace  = var.namespace
  })]
}
