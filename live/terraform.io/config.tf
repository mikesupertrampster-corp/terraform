terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mikesupertrampstr"

    workspaces {
      name = "terraform-io"
    }
  }
}

provider "tfe" {
  token = "XNVJVOYjNy3RyA.atlasv1.MtW8KfrBMmj0eB0jyyFzZebr5BRGbnAfjqqhoXkAUa3ByfyL2qdByx0jnh3xzOpu49g"
}

provider "github" {}
