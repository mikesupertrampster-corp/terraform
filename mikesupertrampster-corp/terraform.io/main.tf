locals {
  user  = "mikesupertrampster"
  org   = "${local.user}-corp"
  email = "${local.user}@gmail.com"
  exec  = "local"
  vcs_repo = {
    vcs  = "github"
    repo = "${local.user}/terraform"
  }

  workspaces = [for path in fileset("${path.root}/..", "**/*/terragrunt.hcl") : replace(path, "//terragrunt.hcl/", "")]
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
    for i, workspace in local.workspaces : (replace(workspace, "/(\\.|/)/", "-")) => {
      GITHUB_TOKEN = var.github_token
      TFE_TOKEN    = "owners"
    }
  }

  workspaces = {
    for i, workspace in local.workspaces : (replace(workspace, "/(\\.|/)/", "-")) => {
      workdir   = "${local.org}/${workspace}"
      exec      = local.exec
      vcs_repo  = local.vcs_repo
      variables = [for i, v in ["GITHUB_TOKEN", "TFE_TOKEN"] : { key = v, category = "env" }]
    }
  }

  modules = formatlist("${local.user}/terraform-module-%s",
    [
      "github-repository",
      "tfe-management",
  ])
}