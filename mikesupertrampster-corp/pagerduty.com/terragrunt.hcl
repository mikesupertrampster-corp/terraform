include {
  path = find_in_parent_folders()
}

inputs = {
  pd_subdomain = "mikesupertrampster-corp"
  pd_region    = "eu"

  users = {
    "John Smith" = {
      email     = "platform@mikesupertrampster.com"
      job_title = "DevOps Engineer"
    }
  }

  teams = {
    "Platform Engineer" = ["John Smith"]
  }
}