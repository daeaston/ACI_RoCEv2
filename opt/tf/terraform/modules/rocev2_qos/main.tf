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

