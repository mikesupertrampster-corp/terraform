# Imported
resource "tfe_organization" "main" {
  name  = module.global.variables["terraform"]["org"]["name"]
  email = module.global.variables["terraform"]["org"]["email"]
}

resource "tfe_workspace" "all" {
  for_each       = toset(["terraform-io", "github-com"])
  name           = each.key
  organization   = tfe_organization.main.id
  queue_all_runs = false
  execution_mode = "local"
}

resource "tfe_variable" "variables" {
  for_each = {
    GITHUB_TOKEN = { workspace = "github-com", category = "env" }
  }

  key          = each.key
  value        = null
  category     = each.value["category"]
  sensitive    = true
  workspace_id = tfe_workspace.all[each.value["workspace"]]["id"]
}