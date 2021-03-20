module "global" {
  source = "../../modules/global"
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mikesupertrampstr"

    workspaces {
      name = "github-com"
    }
  }
}

provider "github" {
  owner = module.global.variables["github"]["owner"]
}