# Understanding the Root main.tf

## Overview

This main.tf file is the entry point for Terraform in the original NAC environment. It connects to two APICs, loads a Netascode ACI module from the Terraform Registry, applies QoS-related configuration using YAML data, and wires in a reset script to clean the lab on destroy. Edit the existing main.tf file by entering ‘vi main.tf’ from this directory

```bash
vi main.tf
```

- Completely overwrite the main.tf file that is directly underneath the nac-aci-simple-example folder with the content below to paste. 

!!! tip "Vi Editor Tips"
    Press **dd** to remove all text line for line, or hold **d** down to remove all lines quickly

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

## Create `main.tf`

```hcl
# This block tells Terraform to use the CiscoDevNet aci provider. Any configuration that references provider "aci" depends on this plugin, ensuring Terraform downloads and uses the correct provider when interacting with the APIC.

terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
  }
}

# Two aci provider blocks are defined—one for each APIC cluster. Each connects to a different fabric using its own URL and credentials, allowing both ACI fabrics to be managed within a single Terraform project.

provider "aci" {
  alias    = "apic1"
  username = "admin"
  password = "C1sco12345"
  url      = "https://198.18.133.200"
}

provider "aci" {
  alias    = "apic2"
  username = "admin"
  password = "C1sco12345"
  url      = "https://198.18.132.200"
}

# Each module block calls the Netascode ACI module, targets a specific APIC, and reads the QoS configuration from the YAML files in the data directory. Access policies are enabled, allowing the same YAML-driven configuration to be applied consistently to both fabrics.


module "apic1_qos" {
  source  = "netascode/nac-aci/aci"
  version = "1.0.1"

  providers = {
    aci = aci.apic1
  }

  yaml_directories = ["data"]

  manage_access_policies    = true
  manage_fabric_policies    = false
  manage_pod_policies       = false
  manage_node_policies      = false
  manage_interface_policies = false
  manage_tenants            = false
}

module "apic2_qos" {
  source  = "netascode/nac-aci/aci"
  version = "1.0.1"

  providers = {
    aci = aci.apic2
  }

  yaml_directories = ["data"]

  manage_access_policies    = true
  manage_fabric_policies    = false
  manage_pod_policies       = false
  manage_node_policies      = false
  manage_interface_policies = false
  manage_tenants            = false
}

# Resetting QoS on Destroy (Calling the Script): Two null_resource blocks define cleanup actions that run only during terraform destroy. They execute the reset_qos.sh script from the project’s scripts folder with different APIC URLs, ensuring QoS is reset on both fabrics:

resource "null_resource" "reset_qos_apic1a" {
  provisioner "local-exec" {
    when    = destroy
    command = "bash ${path.root}/scripts/reset_qos.sh https://apic1-a.corp.pseudoco.com"
  }
}

resource "null_resource" "reset_qos_apic1b" {
  provisioner "local-exec" {
    when    = destroy
    command = "bash ${path.root}/scripts/reset_qos.sh https://apic1-b.corp.pseudoco.com"
  }
}

```

## Save the File

- Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

- Once outside the vi editor, the file can be verified by typing:

```bash
cat main.tf
```

## Next Steps

Proceed to [YAML File](yaml-file.md) to create your NAC YAML configuration.
