# Defining the Username and Password Variables:

variable "admin_username" {
  type    = string
  default = "admin"
}

variable "admin_password" {
  type      = string
  sensitive = true
  default   = "C1sco12345"
}

# Defining the RoCEv2 Policy Inputs like cos, which allow users to set policy behavior without editing Terraform logic:

variable "cos" {
  description = "Class of Service value (e.g., cos3, cos4)"
  type        = string
  default     = "cos3"
}

