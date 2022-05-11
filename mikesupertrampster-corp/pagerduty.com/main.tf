terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
    pagerduty = {
      source = "PagerDuty/pagerduty"
    }
  }
}

provider "pagerduty" {}

resource "pagerduty_team" "teams" {
  for_each = var.teams
  name     = each.key
}

resource "pagerduty_user" "users" {
  for_each  = var.users
  name      = each.key
  email     = each.value["email"]
  job_title = each.value["job_title"]
}

resource "pagerduty_team_membership" "members" {
  for_each = merge(flatten([
    for team, list in var.teams : {
      for i, member in list : "${team}-${member}" => { team = team, member = member }
    }
  ])...)

  team_id = pagerduty_team.teams[each.value["team"]].id
  user_id = pagerduty_user.users[each.value["member"]].id
}

resource "time_static" "now" {}

resource "pagerduty_schedule" "schedules" {
  for_each  = pagerduty_team.teams
  name      = "Daily ${each.value.name} Rotation"
  teams     = [each.value.id]
  time_zone = var.time_zone

  layer {
    name                         = "Day Shift"
    start                        = "${formatdate("YYYY-MM-DD", time_static.now.rfc3339)}T09:00:00+00:00"
    rotation_virtual_start       = "${formatdate("YYYY-MM-DD", time_static.now.rfc3339)}T09:00:00+00:00"
    rotation_turn_length_seconds = 60 * 60 * 24 * 7
    users                        = concat([for i, member in var.teams[each.key] : pagerduty_user.users[member].id])
  }

  lifecycle { ignore_changes = [time_zone] }
}

resource "pagerduty_escalation_policy" "teams" {
  for_each  = pagerduty_schedule.schedules
  name      = each.key
  num_loops = 0
  teams     = [pagerduty_team.teams[each.key].id]

  rule {
    escalation_delay_in_minutes = 30

    target {
      type = "schedule_reference"
      id   = each.value.id
    }
  }
}

resource "datadog_integration_pagerduty" "pd" {
  schedules = concat([for name, schedule in pagerduty_schedule.schedules : "https://${var.pd_subdomain}.${var.pd_region}.pagerduty.com/schedules/${schedule.id}"])
  subdomain = var.pd_subdomain
  api_token = var.dd_pd_api_token
}