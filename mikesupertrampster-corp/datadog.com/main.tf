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

data "datadog_role" "admin" {
  filter = "Datadog Admin Role"
}

resource "datadog_user" "admin" {
  email = "mikesupertrampster@gmail.com"
  roles = [data.datadog_role.admin.id]

  lifecycle {
    create_before_destroy = true
  }
}