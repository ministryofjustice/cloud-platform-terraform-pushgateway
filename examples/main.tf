provider "kubernetes" {}

provider "helm" {
  kubernetes {
  }
}
