variable "org" {
  type    = string
  default = "mikesupertrampstr"
}

variable "email" {
  type    = string
  default = "mikesupertrampster@gmail.com"
}

variable "users" {
  type    = list(string)
  default = ["mikesupertrampstr"]
}

variable "vcs_repo" {
  type    = string
  default = "mikesupertrampster/terraform"
}

variable "workspaces" {
  type    = map(map(string))
  default = {
    "terraform-io"    = {
      workdir = "live/terraform.io"
      exec    = "remote"
    }
    "github-com"      = {
      workdir = "live/github.com"
      exec    = "remote"
    }
    "k8s-development" = {
      workdir = "development/k8s"
      exec    = "local"
    }
  }
}