locals {
  repositories = {
    standalone = {
      nixos     = { visibility = "public", topics = ["nixos", "nix", "linux"] }
      terraform = { visibility = "public", topics = ["terraform", "github", "k8s"] }
      trader    = { visibility = "private", topics = ["finance", "golang", "grafana", "fluxdb"] }
    }

    terraform-module = {
      github-repository = { visibility = "public", topics = ["terraform", "module", "github"] }
    }

    docker-builds = {
      simple-json-server = { visibility = "public", topics = ["docker", "golang", "json", "http"] }
    }
  }
}

module "repositories" {
  for_each = merge(flatten([
    for type, repos in local.repositories : {
      for repo, attr in repos : (tostring(type) == "terraform-module" ? "${type}-${repo}" : repo) => attr
    }
  ])...)

  source                   = "app.terraform.io/mikesupertrampstr/github-repository/module"
  version                  = "1.0.0"
  name                     = each.key
  topics                   = each.value["topics"]
  visibility               = each.value["visibility"]
  required_status_checks   = { "gitleaks" = true }
  github_branch_protection = each.value["visibility"] == "private"
  push_restrictions        = []
}