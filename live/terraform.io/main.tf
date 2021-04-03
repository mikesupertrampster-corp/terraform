locals {
  org            = "mikesupertrampstr"
  gh_user        = "mikesupertrampster"
  email          = "${local.gh_user}@gmail.com"
  terraform_repo = "${local.gh_user}/terraform"
}

variable "github_token" {
  type      = string
  sensitive = true
}

module "terraform-cloud" {
  source  = "app.terraform.io/mikesupertrampstr/tfe-management/module"
  version = "1.0.0"

  org   = local.org
  email = local.email
  users = [local.org]

  github_oauth_token = var.github_token

  workspaces = {
    "terraform-io" = {
      workdir  = "live/terraform.io"
      exec     = "remote"
      vcs_repo = local.terraform_repo

      variables = [
        { key = "GITHUB_TOKEN", category = "env" },
        { key = "TFE_TOKEN", category = "env" },
      ]
    }
    "github-com" = {
      workdir   = "live/github.com"
      exec      = "remote"
      vcs_repo  = local.terraform_repo
      variables = [{ key = "GITHUB_TOKEN", category = "env" }]
    }
    "k8s-development" = {
      workdir   = "development/k8s"
      exec      = "local"
      vcs_repo  = local.terraform_repo
      variables = []
    }
  }

  variables = {
    "terraform-io" = {
      GITHUB_TOKEN = var.github_token
      TFE_TOKEN    = "owners"
    }
    "github-com" = {
      GITHUB_TOKEN = var.github_token
    }
  }

  modules = formatlist("${local.gh_user}/terraform-module-%s", [
    "github-repository",
    "tfe-management",
  ])
}