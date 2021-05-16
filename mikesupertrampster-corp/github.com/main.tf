variable "github_owner" {
  type = string
}

provider "github" {
  owner = var.github_owner
}

locals {
  repositories = {
    standalone = {
      gangway-kube-conf = { topics = ["golang", "k8s", "idp"] }
      nixos             = { topics = ["nixos", "nix", "linux", "os"] }
      packer            = { topics = ["packer", "hashicorp"] }
      terraform         = { topics = ["terraform", "github", "k8s", "hashicorp"], is_template = true }
      trader            = { topics = ["finance", "golang", "grafana", "fluxdb", "prometheus"] }
    }

    terraform-module = {
      github-repository = { topics = ["terraform", "module", "hashicorp", "terraform-registry", "github"], is_template = true }
      tfe-management    = { topics = ["terraform", "module", "hashicorp", "terraform-registry", "terraform-cloud"] }
    }

    docker-builds = {
      simple-json-server = { topics = ["docker", "golang", "json", "http"], is_template = true }
    }

    algo = {
      api             = { topics = ["golang", "json", "http", "finance"], is_template = true }
      batch-collector = { topics = ["golang", "json", "http", "finance"] }
      feeder          = { topics = ["golang", "json", "http", "finance", "prometheus"] }
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
  visibility               = lookup(each.value, "visibility", "public")
  required_status_checks   = { "gitleaks" = true }
  github_branch_protection = true
  is_template              = lookup(each.value, "is_template", false)
  template                 = lookup(each.value, "template", { owner = null, repository = null })
}