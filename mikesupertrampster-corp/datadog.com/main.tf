terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

resource "datadog_api_key" "key" {
  name = "terraform"

  lifecycle {
    ignore_changes = [name]
  }
}

resource "datadog_application_key" "key" {
  name = "terraform"
}
