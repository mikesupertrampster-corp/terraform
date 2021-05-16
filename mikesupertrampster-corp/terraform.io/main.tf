locals {
  user  = "mikesupertrampster"
  org   = "${local.user}-corp"
  email = "${local.user}@gmail.com"
  exec  = "local"
  vcs_repo = {
    vcs  = "github"
    repo = "${local.user}/terraform"
  }
}

variable "github_token" {
  type      = string
  sensitive = true
}

module "terraform-cloud" {
  source  = "app.terraform.io/mikesupertrampster-corp/tfe-management/module"
  version = "1.0.1"

  org   = local.org
  email = local.email
  users = [local.user]

  tfe_oauth_client_token = var.github_token
  tfe_oauth_client = {
    provider = local.vcs_repo.vcs
    api_url  = "https://api.github.com"
    http_url = "https://github.com"
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

  workspaces = {
    "terraform-io" = {
      workdir   = "${local.org}/terraform.io"
      exec      = local.exec
      vcs_repo  = local.vcs_repo
      variables = [for i, v in ["GITHUB_TOKEN", "TFE_TOKEN"] : { key = v, category = "env" }]
    }

    "github-com" = {
      workdir   = "${local.org}/github.com"
      exec      = local.exec
      vcs_repo  = local.vcs_repo
      variables = [for i, v in ["GITHUB_TOKEN"] : { key = v, category = "env" }]
    }

    "k8s-development" = {
      workdir   = "development/k8s"
      exec      = local.exec
      vcs_repo  = local.vcs_repo
      variables = []
    }
  }

  modules = formatlist("${local.user}/terraform-module-%s",
    [
      "github-repository",
      "tfe-management",
  ])
}