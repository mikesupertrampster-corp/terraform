module "repositories" {
  for_each = {
    terraform = {}
    trader    = {}
  }

  source = "../../modules/github/repository"
  name   = each.key
}