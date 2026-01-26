# Cisco Live / DevNet Workshop

# RoCEv2 QoS Automation on Cisco ACI

**Master Lab Manual**

**Prepared by:** David Easton  
**Cisco Systems Engineer – UK&I**  
**Date:** 12th February 2026

![Workshop Banner](assets/images/image001.png)

---

## Table of Contents

### Introduction
- [Introduction to Lab](introduction/overview.md)
- [Lab Outcomes & Objectives](introduction/overview.md#lab-outcomes-objectives)
- [Environment](introduction/overview.md#environment)
- [RoCEv2 Explanation](introduction/rocev2-explained.md)
- [Prerequisites](introduction/prerequisites.md)
- [Topology](introduction/getting-started.md#topology)
- [Getting Started](introduction/getting-started.md)

### Lab Exercises

#### [Lab 1: Terraform Classic)](lab-guides/lab1-terraform-custom/introduction-to-terraform.md)
1. [Introduction to Terraform](lab-guides/lab1-terraform-custom/introduction-to-terraform.md)
2. [Install Terraform on Tools Machine](lab-guides/lab1-terraform-custom/install-terraform.md)
3. [Terraform Concepts: Root vs. Child Modules](lab-guides/lab1-terraform-custom/terraform-concepts.md)
4. [Building the Terraform Root Module](lab-guides/lab1-terraform-custom/root-module.md)
5. [Building the Child Module (rocev2_qos)](lab-guides/lab1-terraform-custom/child-module.md)
6. [Script Integration & Clean-Up](lab-guides/lab1-terraform-custom/script-integration.md)
7. [Opening APIC GUI's and applying Terraform Commands](lab-guides/lab1-terraform-custom/apply-terraform.md)

#### [Lab 2: Terraform NAC](lab-guides/lab2-terraform-nac/introduction-to-nac.md)
1. [Introduction to NAC](lab-guides/lab2-terraform-nac/introduction-to-nac.md)
2. [NAC Environment Setup](lab-guides/lab2-terraform-nac/nac-setup.md)
3. [Understanding the Root main.tf](lab-guides/lab2-terraform-nac/root-main-tf.md)
4. [NAC YAML File: qos_rocev2.nac.yaml](lab-guides/lab2-terraform-nac/yaml-file.md)
5. [Understanding qos_rocev2.nac.yaml](lab-guides/lab2-terraform-nac/understanding-yaml.md)
6. [NAC Script Integration](lab-guides/lab2-terraform-nac/script-integration.md)
7. [Opening APIC GUI's and applying Terraform Commands](lab-guides/lab2-terraform-nac/apply-terraform.md)

#### [Lab 3: Python](lab-guides/lab3-python/python-overview.md)
1. [Python Overview](lab-guides/lab3-python/python-overview.md)
2. [Verifying Python](lab-guides/lab3-python/verify-python.md)
3. [Executing the Python Script](lab-guides/lab3-python/execute-script.md)

#### [Lab 4: Bruno](lab-guides/lab4-bruno/bruno-overview.md)
1. [Bruno Overview](lab-guides/lab4-bruno/bruno-overview.md)
2. [Import Collection](lab-guides/lab4-bruno/import-collection.md)
3. [Configure Environment](lab-guides/lab4-bruno/configure-environment.md)
4. [Create QoS Policy](lab-guides/lab4-bruno/create-qos-policy.md)

#### [Lab 5: Ansible](lab-guides/lab5-ansible/ansible-overview.md)
1. [Ansible Overview](lab-guides/lab5-ansible/ansible-overview.md)
2. [Setup Directory Structure](lab-guides/lab5-ansible/setup-directory.md)
3. [Inventory File](lab-guides/lab5-ansible/inventory-file.md)
4. [Group Variables File](lab-guides/lab5-ansible/group-vars-file.md)
5. [Apply QoS Playbook](lab-guides/lab5-ansible/apply-qos-playbook.md)
6. [Reset QoS Playbook](lab-guides/lab5-ansible/reset-qos-playbook.md)
7. [Login to APICs](lab-guides/lab5-ansible/login-apics.md)
8. [Run Playbooks](lab-guides/lab5-ansible/run-playbooks.md)

### [Conclusion](Conclusion.md)

### [Appendicies](appendicies.md)

---

## Workshop Overview

This comprehensive lab manual provides a structured, end-to-end workshop for configuring and automating RoCEv2 QoS across ACI fabrics. It leverages a multi-workflow approach, demonstrating automation using:

- **Terraform** (Custom modules and Netascode NAC)
- **Python** with ACI SDK
- **Bruno** API client
- **Ansible** (bonus content)

This guide is designed for Cisco Live DevNet, dCloud, CPOC, or customer-facing training environments, aiming to equip participants with practical skills for building modern, lossless AI-ready transport environments.

---

## Getting Started

Ready to begin? Start with the [Introduction](introduction/overview.md) to understand the lab environment and objectives.
