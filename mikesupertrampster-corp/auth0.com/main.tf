terraform {
  required_providers {
    auth0 = {
      source  = "alexkappa/auth0"
    }
  }
}

provider "auth0" {
  domain = "mikesupertrampster.eu.auth0.com"
}