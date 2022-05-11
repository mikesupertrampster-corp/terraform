variable "time_zone" {
  type    = string
  default = "UTC"
}

variable "services" {
  type = map(map(string))
}

variable "teams" {
  type = map(list(string))
}

variable "users" {
  type = map(object({
    email     = string
    job_title = string
  }))
}
