module "pushgateway" {
  source    = "../" # use the latest release
  # source    = "github.com/ministryofjustice/cloud-platform-terraform-pushgateway?ref=version" # use the latest relase
  
  namespace = var.namespaced
}
