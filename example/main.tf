provider "kubernetes" {
  version = "~> 1.11"
}

provider "helm" {
  kubernetes {
  }
}
