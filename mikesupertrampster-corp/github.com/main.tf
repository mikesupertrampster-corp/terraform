provider "github" {
  owner = "mikesupertrampster-corp"
}

data "github_user" "current" { username = "" }

locals {
  owner = data.github_user.current.name

  templates = {
    docker           = { owner = local.owner, repository = "simple-json-server" }
    go               = { owner = local.owner, repository = "algo-api" }
    terraform-module = { owner = local.owner, repository = "terraform-module-github-repository" }
    terraform        = { owner = local.owner, repository = "terraform" }
  }

  repositories = {
    standalone = {
      gangway-kube-conf = { visibility = "public", topics = ["golang", "k8s", "idp"] }
      nixos             = { visibility = "public", topics = ["nixos", "nix", "linux", "os"] }
      packer            = { visibility = "public", topics = ["packer", "hashicorp"] }
      terraform         = { visibility = "public", topics = ["terraform", "github", "k8s", "hashicorp"] }
      trader            = { visibility = "public", topics = ["finance", "golang", "grafana", "fluxdb", "prometheus"] }
    }

    terraform-module = {
      github-repository = { visibility = "public", topics = ["terraform", "module", "github", "hashicorp", "terraform-registry"] }
      tfe-management    = { visibility = "public", topics = ["terraform", "module", "hashicorp", "terraform-registry", "terraform-cloud"] }
    }

    docker-builds = {
      simple-json-server = { visibility = "public", topics = ["docker", "golang", "json", "http"] }
    }

    algo = {
      api             = { visibility = "public", topics = ["golang", "json", "http", "finance"] }
      batch-collector = { visibility = "public", topics = ["golang", "json", "http", "finance"] }
      feeder          = { visibility = "public", topics = ["golang", "prometheus", "json", "http", "finance"] }
    }
  }

  prepend-category = ["terraform-module", "algo"]
}

module "repositories" {
  for_each = merge(flatten([
    for type, repos in local.repositories : {
      for repo, attr in repos : (contains(local.prepend-category, type) ? "${type}-${repo}" : repo) => attr
    }
  ])...)

  source                   = "app.terraform.io/mikesupertrampster-corp/github-repository/module"
  version                  = "1.0.5"
  name                     = each.key
  topics                   = each.value["topics"]
  visibility               = each.value["visibility"]
  required_status_checks   = { "gitleaks" = true }
  github_branch_protection = each.value["visibility"] == "private"
  is_template              = contains([for t in values(local.templates) : t["repository"]], each.key)
  template                 = lookup(each.value, "template", { owner = null, repository = null })
  push_restrictions        = []
}