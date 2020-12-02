provider "kubernetes" {
  version = "~> 1.11"
}

provider "helm" {
  version = "1.1.0"
  kubernetes {
  }
}