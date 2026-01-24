# Declaring the Required Provider - The terraform block specifies the required ACI provider, ensuring consistency and repeatability by pinning the version.

terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = "~> 2.16.0"
    }
  }
}

# Two aci provider blocks are defined—one for each APIC cluster—using aliases to distinguish the fabrics. Each provider uses variables for the APIC URL and credentials, allowing Terraform to manage both ACI fabrics in a single run.

provider "aci" {
  alias    = "apic1-a"
  username = var.admin_username
  password = var.admin_password
  url      = "https://apic1-a.corp.pseudoco.com"
  insecure = true
}

provider "aci" {
  alias    = "apic1-b"
  username = var.admin_username
  password = var.admin_password
  url      = "https://apic1-b.corp.pseudoco.com"
  insecure = true
}

# The rocev2_qos module is reused for each APIC, with provider binding and inputs adjusted per fabric to ensure consistent QoS configuration.

module "qos_apic1_a" {
  source    = "./modules/rocev2_qos"
  providers = { aci = aci.apic1-a }

  admin_username = var.admin_username
  admin_password = var.admin_password
  apic_url       = "https://apic1-a.corp.pseudoco.com"
  cos            = var.cos
}

module "qos_apic1_b" {
  source    = "./modules/rocev2_qos"
  providers = { aci = aci.apic1-b }

  admin_username = var.admin_username
  admin_password = var.admin_password
  apic_url       = "https://apic1-b.corp.pseudoco.com"
  cos            = var.cos
}

