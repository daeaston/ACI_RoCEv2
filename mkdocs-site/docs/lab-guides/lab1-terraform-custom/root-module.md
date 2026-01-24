# Building the Terraform Root Module

## Overview

In this section, you will build the root Terraform module that orchestrates the deployment of RoCEv2 QoS policies to both ACI fabrics (APIC1-A and APIC1-B).

## Working Directory

Ensure you're in the correct directory:

```bash
cd /opt/
mkdir tf
cd tf
mkdir terraform
cd terraform
```

Create the root main.tf file by executing the command ‘vi main.tf’ and pasting the following content:

```bash
vi main.tf
```

## Step 1: Create `main.tf`

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

```hcl
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

```
## Save the File

Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

Once outside the vi editor, the file can be verified by typing:

```bash
cat main.tf
```

## Step 2: Create `variables.tf`

Create the root variables.tf file by executing the command ‘vi variables.tf’ and pasting the following content:

```bash
vi variables.tf
```

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

Define the input variables:

```hcl
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

```

## Save the File

Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

Once outside the vi editor, the file can be verified by typing:

```bash
cat variables.tf
```

## Directory Structure

Your directory should now look like this:

```
/opt/tf/
├── main.tf
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
└── modules/
    └── rocev2_qos/       # (Created in next step)
```

!!! success "Root Module Complete"
    Your root module is now ready! It will deploy the same RoCEv2 QoS configuration to both ACI fabrics.

## Next Steps

Proceed to [Building the Child Module](child-module.md) to create the reusable RoCEv2 QoS module.
