# Labels
variable "owner" { 
  description = "Email address of the instance owner."
  default = "" 
}

variable "name" {
  description = "Short name for use across all AWS resouves."
  default = "terraform"
}

variable "environment" { 
  description = "Valid values are 'dev', 'uat', 'prod'."
  default = "dev"
}

variable "namespace-org" {
  description = "Use true to include namesapce in the label (namespace-stage/environment-name)."
  default = true
}

variable "org" {
  description = "Organisation name."
  default = "leaf"
}

variable "service" {
  description = "Service name. Optional."
  default = ""
}

variable "product" {
  description = "Produt name. Optional."
  default = ""
}

variable "team" {
  description = "Team name."
  default = "research-technologies"
}