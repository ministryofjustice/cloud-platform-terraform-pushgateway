provider "kubernetes" {
  version = "~> 2.18.0"
}

provider "helm" {
  kubernetes {
  }
}
