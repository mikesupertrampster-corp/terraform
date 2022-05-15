terraform {
  required_providers {
    configcat = {
      source = "configcat/configcat"
    }
  }
}

provider "configcat" {}

data "configcat_organizations" "org" {
  name_filter_regex = "Mikesupertrampster"
}

resource "configcat_product" "product" {
  organization_id = data.configcat_organizations.org.organizations.0.organization_id
  name            = "mikesupertrampster"
}

resource "configcat_environment" "my_environment" {
  for_each = {
    Production  = "red"
    Development = "blue"
  }
  product_id = configcat_product.product.id
  name       = each.key
  color      = each.value
}

resource "configcat_config" "main" {
  product_id = configcat_product.product.id
  name       = "Main Config"
}


resource "configcat_setting" "setting" {
  config_id    = configcat_config.main.id
  key          = "isAwesomeFeatureEnabled"
  name         = "My awesome feature flag"
  hint         = "This is the hint for my awesome feature flag"
  setting_type = "boolean"
}
