terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mikesupertrampstr"

    workspaces {
      name = "github-com"
    }
  }
}

provider "github" {}