include {
  path = find_in_parent_folders()
}

inputs = {
  users = {
    "John Smith" = {
      email     = "platform@mikesupertrampster.com"
      job_title = "DevOps Engineer"
    }
  }

  teams = {
    "Platform Engineer" = ["John Smith"]
  }

  services = {
    vault = {
      team = "Platform Engineer"
    }
  }
}