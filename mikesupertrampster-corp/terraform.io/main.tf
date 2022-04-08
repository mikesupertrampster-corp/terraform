locals {
  exec  = "local"
  vcs_repo = {
    vcs  = "github"
    repo = "${var.terraform_org}/terraform"
  }

  workspaces = concat(
    [for path in fileset("${path.root}/..", "**/*/terragrunt.hcl") : replace(path, "//terragrunt.hcl/", "")],
    ["aws-root", "aws-dev"]
  )
}

module "terraform-cloud" {
  source  = "app.terraform.io/mikesupertrampster-corp/tfe-management/module"
  version = "1.0.1"

  org   = var.terraform_org
  email = var.terraform_user_email
  users = [var.terraform_user]

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
      workdir   = "${var.terraform_org}/${workspace}"
      exec      = local.exec
      vcs_repo  = local.vcs_repo
      variables = [for i, v in ["GITHUB_TOKEN", "TFE_TOKEN"] : { key = v, category = "env" }]
    }
  }

  modules = formatlist("${var.terraform_user}/terraform-module-%s",
    [
      "github-repository",
      "tfe-management",
  ])
}