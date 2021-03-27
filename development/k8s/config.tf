terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mikesupertrampstr"

    workspaces {
      name = "k8s-development"
    }
  }

  required_providers {
    kind = {
      source  = "unicell/kind"
      version = "0.0.2-u2"
    }
  }
}

provider "kind" {}