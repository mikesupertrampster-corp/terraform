terraform {
  required_providers {
    kind = {
      source = "unicell/kind"
    }
  }
}

resource "kind_cluster" "local" {
  name           = "terraform"
  node_image     = "kindest/node:v1.20.2"
  wait_for_ready = true
}

data "local_file" "kubeconfig" {
  filename = kind_cluster.local["kubeconfig_path"]
}
