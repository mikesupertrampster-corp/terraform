include {
  path = find_in_parent_folders()
}

inputs = {
  github_token = get_env("GITHUB_TOKEN")
}