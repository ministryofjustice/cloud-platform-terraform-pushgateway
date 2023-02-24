
module "pushgateway" {
  # always check the latest release in Github and set below
  source    = "../"
  # source    = "github.com/ministryofjustice/cloud-platform-terraform-pushgateway?ref=1.2"
  namespace = "example-namespace"
}


