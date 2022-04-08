include {
  path = find_in_parent_folders()
}

inputs = {
  github_token         = get_env("GITHUB_TOKEN")
  terraform_org        = "mikesupertrampster-corp"
  terraform_user_email = "mikesupertrampster@gmail.com"
  terraform_user       = "mikesupertrampster"
}