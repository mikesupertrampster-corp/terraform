module "repositories" {
  for_each = {
    nixos     = { visibility = "public", topics = ["nixos", "nix", "linux"] }
    terraform = { visibility = "private", topics = ["terraform", "github", "k8s"] }
    trader    = { visibility = "private", topics = ["finance", "golang", "grafana", "fluxdb"] }
  }

  source     = "../../modules/github/repository"
  name       = each.key
  topics     = each.value["topics"]
  visibility = each.value["visibility"]
}