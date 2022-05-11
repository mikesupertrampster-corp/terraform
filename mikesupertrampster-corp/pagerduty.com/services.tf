resource "pagerduty_business_service" "services" {
  for_each = var.services
  name     = each.key
  team     = pagerduty_team.teams[each.value["team"]].id
}

resource "pagerduty_service" "services" {
  for_each          = var.services
  name              = each.key
  escalation_policy = pagerduty_escalation_policy.teams[each.value["team"]].id
  alert_creation    = "create_alerts_and_incidents"
}

resource "pagerduty_service_dependency" "foo" {
  for_each = var.services

  dependency {
    dependent_service {
      id   = pagerduty_business_service.services[each.key].id
      type = pagerduty_business_service.services[each.key].type
    }
    supporting_service {
      id   = pagerduty_service.services[each.key].id
      type = pagerduty_service.services[each.key].type
    }
  }
}
