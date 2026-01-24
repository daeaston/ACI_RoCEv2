#  Class of Service value (default cos3) used for no-drop RoCEv2 traffic, which is inserted into the XML payload for PFC:

variable "cos" {
  description = "Class of service value"
  type        = string
  default     = "cos3"
}

# apic_url, admin_username, and admin_password define how Terraform connects to the APIC. These values are provided by the root module, allowing the same module to be reused across multiple fabrics. The password is marked sensitive to prevent accidental exposure:

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "apic_url" {
  type = string
}

