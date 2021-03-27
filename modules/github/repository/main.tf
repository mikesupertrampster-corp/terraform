resource "github_repository" "repository" {
  name        = var.name
  description = var.description
  topics      = var.topics
  visibility  = var.visibility

  has_downloads = var.has_downloads
  has_issues    = var.has_issues
  has_projects  = var.has_projects
  has_wiki      = var.has_wiki

  delete_branch_on_merge = true
  vulnerability_alerts   = true
}

resource "github_branch" "master" {
  repository = github_repository.repository.id
  branch     = var.default_branch
}

resource "github_branch_default" "default" {
  repository = github_repository.repository.name
  branch     = github_branch.master.branch
}
