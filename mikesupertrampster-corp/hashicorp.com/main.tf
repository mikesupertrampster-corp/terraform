terraform {
  required_providers {
    hcp = {
      source = "hashicorp/hcp"
    }
  }
}

variable "cluster_id" {
  type = string
}

variable "region" {
  type = string
}

resource "hcp_hvn" "vault" {
  hvn_id         = "hvn"
  cloud_provider = "aws"
  region         = var.region
  cidr_block     = "172.25.16.0/20"
}

resource "hcp_vault_cluster" "vault" {
  cluster_id = var.cluster_id
  hvn_id     = hcp_hvn.vault.hvn_id
}

resource "hcp_vault_cluster_admin_token" "admin" {
  cluster_id = hcp_vault_cluster.vault.cluster_id
}