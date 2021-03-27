variable "name" {
  type = string
}

variable "visibility" {
  type    = string
  default = "private"
}

variable "has_downloads" {
  type    = bool
  default = false
}

variable "has_issues" {
  type    = bool
  default = false
}

variable "has_projects" {
  type    = bool
  default = false
}

variable "has_wiki" {
  type    = bool
  default = false
}

variable "default_branch" {
  type    = string
  default = "master"
}

variable "description" {
  type    = string
  default = "Maintained by Terraform"
}

variable "topics" {
  type    = list(string)
  default = []
}