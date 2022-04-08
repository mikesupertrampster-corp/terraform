variable "github_owner" {
  type = string
}

provider "github" {
  owner = var.github_owner
}

locals {
  repositories = {
    standalone = {
      aws               = { topics = ["aws", "cloud", "iac", "terraform"], is_template = true, description = "AWS Setup via Terraform" }
      gangway-kube-conf = { topics = ["golang", "k8s", "idp"], description = "Commandline to obtain kube-configuration via gangway" }
      nixos             = { topics = ["nixos", "nix", "linux", "os"], description = "NixOS and Home-Manager configurations" }
      packer            = { topics = ["packer", "hashicorp"], description = "Building images via Hashicorp Packer" }
      terraform         = { topics = ["terraform", "github", "k8s", "hashicorp"], is_template = true, description = "Terraform for Everything" }
      trader            = { topics = ["finance", "golang", "grafana", "fluxdb", "prometheus"], description = "Trader platform using Prometheus & Grafana" }
      yubikey           = { topics = ["security", "yubikey"], description = "Set up guide for Yubikey (GPG + SSH)" }
    }

    terraform-module = {
      github-repository = { topics = ["terraform", "module", "hashicorp", "terraform-registry", "github"], is_template = true, description = "Terraform module for creating creating Github repositories" }
      tfe-management    = { topics = ["terraform", "module", "hashicorp", "terraform-registry", "terraform-cloud"], description = "Terraform modules for setting up TF Cloud" }
    }

    docker-builds = {
      simple-json-server = { topics = ["docker", "golang", "json", "http"], is_template = true, description = "Dynamically serves JSON from files" }
    }

    algo = {
      api             = { topics = ["golang", "json", "http", "finance"], is_template = true, description = "Interacts with the following company information services" }
      batch-collector = { topics = ["golang", "json", "http", "finance"], description = "Collects company information via service API" }
      feeder          = { topics = ["golang", "json", "http", "finance", "prometheus"], description = "Sends company information to Prometheus database" }
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
  description              = lookup(each.value, "description", null)
  topics                   = each.value["topics"]
  visibility               = lookup(each.value, "visibility", "public")
  required_status_checks   = { "gitleaks" = true }
  github_branch_protection = true
  is_template              = lookup(each.value, "is_template", false)
  template                 = lookup(each.value, "template", { owner = null, repository = null })
}