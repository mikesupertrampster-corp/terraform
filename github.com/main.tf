resource "github_repository" "repos" {
  for_each    = {
    terraform = {}
  }
  name        = each.key
  visibility  = "private"
}