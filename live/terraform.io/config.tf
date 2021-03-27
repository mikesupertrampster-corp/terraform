module "global" {
  source = "../../modules/global"
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mikesupertrampstr"

    workspaces {
      name = "terraform-io"
    }
  }
}

provider "tfe" {}

provider "github" {
  organization = module.global.variables["github"]["org"]
}