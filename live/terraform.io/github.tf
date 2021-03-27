resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 3072
}

resource "tfe_oauth_client" "github" {
  organization     = tfe_organization.main.id
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = "GITHUB TOKEN"
  service_provider = "github"

  lifecycle {
    ignore_changes = [oauth_token]
  }
}

resource "tfe_ssh_key" "github" {
  name         = tfe_oauth_client.github.service_provider
  organization = tfe_organization.main.id
  key          = tls_private_key.rsa.private_key_pem
}

resource "github_user_ssh_key" "tfe" {
  count = 0
  title = "Terraform Cloud"
  key   = tls_private_key.rsa.public_key_openssh
}
