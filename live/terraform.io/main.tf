# Imported
resource "tfe_organization" "main" {
  name  = var.org
  email = var.email

  lifecycle {
    ignore_changes = [email]
  }
}

# Imported
resource "tfe_team" "teams" {
  for_each     = toset(["owners"])
  name         = each.key
  organization = tfe_organization.main.id
}

resource "tfe_workspace" "all" {
  for_each          = var.workspaces
  name              = each.key
  organization      = tfe_organization.main.id
  queue_all_runs    = true
  execution_mode    = each.value["exec"]
  working_directory = each.value["workdir"]

  vcs_repo {
    identifier         = var.vcs_repo
    ingress_submodules = false
    oauth_token_id     = ""
  }

  lifecycle {
    ignore_changes = [vcs_repo.0.oauth_token_id]
  }
}

resource "tfe_variable" "variables" {
  for_each = {
    github-com   = { key = "GITHUB_TOKEN", category = "env" }
    terraform-io = { key = "GITHUB_TOKEN", category = "env" }
  }

  key          = each.value["key"]
  value        = null
  category     = each.value["category"]
  sensitive    = true
  workspace_id = tfe_workspace.all[each.key]["id"]
}

resource "tfe_team_member" "members" {
  for_each = merge(flatten([for key, value in tfe_team.teams :
    [for user in var.users : { tostring(user) = value["id"] }]
  ])...)

  team_id  = each.value
  username = each.key
}
