terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mikesupertrampstr"

    workspaces {
      name = "github-com"
    }
  }
}

module "global" {
  source = "../../modules/global"
}

provider "github" {}