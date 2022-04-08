terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "datadog" {}

resource "datadog_api_key" "key" {
  name = "terraform"

  lifecycle {
    ignore_changes = [name]
  }
}

resource "datadog_application_key" "key" {
  name = "terraform"
}
