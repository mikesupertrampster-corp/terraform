terraform {
  required_providers {
    auth0 = {
      source = "auth0/auth0"
    }
  }
}

provider "auth0" {
  domain = var.auth0_domain
}

resource "auth0_client" "terraform" {
  name     = "Terraform Auth0 Provider"
  app_type = "non_interactive"
  logo_uri = "https://symbols.getvecta.com/stencil_97/45_terraform-icon.0fedccc574.svg"
}