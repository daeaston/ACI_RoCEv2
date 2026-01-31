# Lab 1: Terraform Classic

![Terraform Logo](../../assets/images/image040.png)

## Overview

HashiCorp Terraform (often called classic Terraform, to distinguish it from NAC/Netascode) is a widely adopted Infrastructure-as-Code tool because it offers a consistent, declarative way to manage infrastructure across many platforms. Engineers describe the desired end state using HCL, and Terraform automatically works out dependencies, ordering, and the minimum set of changes required.

One of Terraforms biggest strengths is its provider ecosystem. Thousands of official and community providers allow it to manage public cloud, private cloud, networking, security, SaaS, and on-prem infrastructure from a single workflow. Features like state management, plan/apply, drift detection, and reusable modules make it well suited to large, repeatable, and auditable environments.

Compared to other IaC tools, Terraform is highly platform-agnostic. Configuration tools such as Ansible are excellent for procedural tasks and day-2 operations, but they lack Terraforms built-in state awareness and drift tracking:

## Optional Resources

- [Terraform Introduction](https://developer.hashicorp.com/terraform/intro) - General overview of Terraform from the Hashicorp Website.
- [ACI Terraform Provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs) - Central place on the Terraform Registry where all ACI resources and data sources are documented. Shows the full list of objects that can be managed in ACI (tenants, EPGs, BDs, VRFs, contracts, filters, etc.) and how to use them for .tf files.
- [ACI Terraform QoS Documentation)](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/qos_instance_policy) – Specific modules for QoS
- [ACI Modules Terraform Registry](https://registry.terraform.io/providers/CiscoDevNet/aci/latest) - to browse a large number of ACI modules that package common use-cases and patterns for ACI automation (often reusable building blocks) in Github.
- [Devnet Lab on Terraform for ACI](https://developer.cisco.com/learning/search/?contentType=lab&page=1) - optional extra Lab to walk through for a later date.
- [Video on Tarraform & Ansible Programmability](https://video.cisco.com/detail/video/6371473476112)

## Next Steps

Proceed to [Install Terraform](install-terraform.md).
