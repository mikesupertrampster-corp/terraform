variable "name" {
  type    = string
  default = "mikesupertrampstr"
}

output "variables" {
  value = {
    github = {
      org            = "mikesupertrampster"
      default_branch = "master"
    }
    terraform = {
      org = {
        name  = var.name
        email = "mikesupertrampster@gmail.com"
        users = [var.name]
      }
    }
  }
}