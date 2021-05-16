include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_id = basename(get_parent_terragrunt_dir())
}