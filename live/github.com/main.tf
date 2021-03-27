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
  }
}

module "repositories" {
  for_each = merge(flatten([
    for type, repos in local.repositories : {
      for repo, attr in repos : (tostring(type) == "standalone" ? repo : "${type}-${repo}") => attr
    }
  ])...)

  source                 = "../../modules/github/repository"
  name                   = each.key
  topics                 = each.value["topics"]
  visibility             = each.value["visibility"]
  required_status_checks = { Gitleaks = true }
}