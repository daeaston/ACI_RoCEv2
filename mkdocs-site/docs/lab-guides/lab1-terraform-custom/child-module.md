# Building the Child Module (rocev2_qos)

## Overview

In this section, you will create a reusable Terraform child module that implements RoCEv2 QoS configuration for ACI. This module can be called multiple times to deploy the same configuration to different fabrics or tenants.

## Create Module Directory

- Create the module directory structure:

```bash
cd /opt/tf/terraform
mkdir modules
cd modules
mkdir rocev2_qos
cd rocev2_qos
```

The child main.tf file contains the implementation logic for the RoCEv2 QoS configuration. While the root main.tf decides which APICs to target and how many times to call this module, the child main.tf defines what is built on the ACI fabric.

- Create the child main.tf file by executing the command ‘vi main.tf’ and pasting the following content:

```bash
vi main.tf
```

## Step 1: Create `main.tf`

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

- Define the module's input variables:

```hcl
# Declaring the ACI Provider Requirement (ciscodevnet/aci), allowing it to be reused while clearly stating its dependency:

terraform {
  required_providers {
    aci = {
      source = "ciscodevnet/aci"
    }
  }
}

# Creating the QoS Class (Level 2) with class_name = "qosClass" and dn = "uni/infra/qosinst-default/class-level2". enabling it (admin = "enabled") and assigning priority level2. This forms the foundation for congestion and PFC policies:

resource "aci_rest_managed" "qos_class_level2" {
  class_name = "qosClass"
  dn         = "uni/infra/qosinst-default/class-level2"
  content = {
    admin = "enabled"
    prio  = "level2"
  }
}

# Applies congestion management settings to the QoS class, enabling WRED and ECN to detect and signal congestion for this traffic class.

resource "aci_rest_managed" "qos_class_congestion" {
  class_name = "qosCong"
  dn         = "${aci_rest_managed.qos_class_level2.dn}/cong"
  content = {
    algo             = "wred"
    wredMaxThreshold = "60"
    wredMinThreshold = "40"
    wredProbability  = "10"
    ecn              = "enabled"
    forwardNonEcn    = "enabled"
  }
}

# Creating/Modifying the QoS Scheduling Policy (child of qosClass).

resource "aci_rest_managed" "qos_class_scheduling" {
  class_name = "qosSched"
  dn                 = "${aci_rest_managed.qos_class_level2.dn}/sched"
  content = {
    bw = "60"
  }
}

# This script configures Priority Flow Control (PFC) by calling the APIC APIs directly. A null_resource runs curl commands to log into the APIC and post an XML payload for the specified noDropCos. 

resource "null_resource" "enable_pfc_via_curl" {
  provisioner "local-exec" {
    command = <<EOT
curl -sk -X POST ${var.apic_url}/api/aaaLogin.json \
  -H "Content-Type: application/json" \
  -d '{"aaaUser":{"attributes":{"name":"${var.admin_username}","pwd":"${var.admin_password}"}}}' \
  -c apic-cookie.txt

curl -sk -X POST ${var.apic_url}/api/node/mo/uni.xml \
  -H "Content-Type: application/xml" \
  -d '<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
         <qosPfcPol name="default" noDropCos="${var.cos}" adminSt="yes" enableScope="fabric"/>
       </qosClass>' \
  -b apic-cookie.txt
EOT
  }
}

# Two null_resource cleanup hooks run during terraform destroy, calling a shared reset_qos.sh script to reset QoS on both APICs and leave the lab environment clean

resource "null_resource" "reset_qos_apic1a" {
  provisioner "local-exec" {
    when    = destroy
    command = "bash ${path.module}/../../scripts/reset_qos.sh https://apic1-a.corp.pseudoco.com"
  }
}

resource "null_resource" "reset_qos_apic1b" {
  provisioner "local-exec" {
    when    = destroy
    command = "bash ${path.module}/../../scripts/reset_qos.sh https://apic1-b.corp.pseudoco.com"
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

## Step 2: Create `variables.tf`

This child variables.tf file defines the input parameters that the RoCEv2 QoS module expects from the root module. While the root variables.tf captures values from the lab user, the child variables.tf describes what this module needs to build the configuration on a given APIC.

- Create the child variables.tf file by executing the command ‘vi variables.tf’ and pasting the following content:

```bash
vi variables.tf
```

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

- Implement the RoCEv2 QoS resources:

```hcl
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

```

## Save the File

- Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

- Once outside the vi editor, the file can be verified by typing:

```bash
cat variables.tf
```

In summary, the child module main.tf focuses entirely on what QoS and RoCEv2-related configuration is applied to the fabrics.

## Module Structure

Your module directory should now contain:

```
/opt/tf/modules/rocev2_qos/
├── main.tf
├── variables.tf
```

!!! success "Module Complete"
    Your reusable RoCEv2 QoS module is now ready to be deployed!

## Next Steps

Proceed to [Script Integration](script-integration.md) to create helper scripts for managing the configuration.
