variable "dd_pd_api_token" {
  type      = string
  sensitive = true
}

variable "pd_region" {
  type = string
}

variable "pd_subdomain" {
  type = string
}

variable "time_zone" {
  type    = string
  default = "UTC"
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
