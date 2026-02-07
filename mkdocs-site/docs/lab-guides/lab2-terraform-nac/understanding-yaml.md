# Understanding qos_rocev2.nac.yaml

## Overview

This section explains each component of the NAC YAML configuration and how it implements RoCEv2 QoS on ACI.

## Configuration Breakdown

This YAML file defines the RoCEv2 QoS policy in a declarative way for the Netascode nac-aci Terraform module. Instead of writing all the ACI objects directly in Terraform, the intent in YAML is described, and the Netascode module translates it into the appropriate ACI MOs (such as qosClass, qosCong, and qosPfcPol).

**Top-Level Structure** The structure apic: access_policies: qos: qos_classes: indicates that this YAML defines QoS-related access policies for the APIC, specifically a list of QoS classes.

**Defining the RoCEv2 QoS Class** This single YAML block describes the QoS behavior for class level: 2, which maps to qosClass level2 in ACI.

**level: 2** Sets the QoS class level, corresponding to uni/infra/qosinst-default/class-level2 in ACI. This is the class you use for RoCEv2 / no-drop traffic.

**congestion_algorithm: wred** Selects WRED for congestion management, mapping to algo = "wred" in ACI. Combined with thresholds below, it defines how congestion is detected and when early drops/marks occur:

- **wred_min_threshold: 40** → start threshold (e.g. 40%)
- **wred_max_threshold: 60** → max threshold (e.g. 60%)
- **wred_probability: 10** → drop/mark probability at those thresholds

**ecn: true** Enables Explicit Congestion Notification, mapping to ecn = "enabled". This means congestion can be signalled via ECN marks rather than relying only on packet drops.

**forward_non_ecn: true** Enables the forwarding of traffic that has not been marked with Explicit Congestion Notification (ECN). This maps to forwardNonEcn = "enabled" within the qosCong MO in ACI.

**bandwidth_percent: 60** Allocates a specific percentage of the available bandwidth to this QoS class. This maps to bw = "60" within the qosSched MO in ACI, ensuring a guaranteed bandwidth share for this traffic.

**pfc_state: true** Turns Priority Flow Control (PFC) on, mapping to adminSt = "yes" for qosPfcPol. PFC ensures that traffic in the selected CoS can be treated as no-drop (crucial for RoCEv2).

**no_drop_cos: cos3** Specifies cos3 as the no-drop Class of Service, mapping to noDropCos = "cos3". This aligns nicely with the Terraform variable you use elsewhere (var.cos), and makes it explicit in human-readable YAML.

**pfc_scope: fabric** Defines the scope of the PFC policy as fabric-wide.

How This YAML Relates to the Terraform: In the main.tf, yaml_directories = ["data"] tells the Netascode module to read all .nac.yaml files in the data/ directory, including qos_rocev2.nac.yaml. The module then converts this YAML intent into the appropriate ACI MOs for both APIC1 and APIC2.

## Next Steps

Proceed to [Script Integration](script-integration.md) to create helper scripts for the NAC deployment.
