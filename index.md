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

#### [Lab 1: Terraform Automation (Custom Module)](lab-guides/lab1-terraform-custom/install-terraform.md)
1. [Install Terraform on Tools Machine](lab-guides/lab1-terraform-custom/install-terraform.md)
2. [Terraform Concepts: Root vs. Child Modules](lab-guides/lab1-terraform-custom/terraform-concepts.md)
3. [Building the Terraform Root Module](lab-guides/lab1-terraform-custom/root-module.md)
4. [Building the Child Module (rocev2_qos)](lab-guides/lab1-terraform-custom/child-module.md)
5. [Script Integration & Clean-Up](lab-guides/lab1-terraform-custom/script-integration.md)
6. [Opening APIC GUI's and applying Terraform Commands](lab-guides/lab1-terraform-custom/apply-terraform.md)

#### [Lab 2: Terraform NAC Approach](lab-guides/lab2-terraform-nac/nac-setup.md)
1. [NAC Environment Setup](lab-guides/lab2-terraform-nac/nac-setup.md)
2. [Understanding the Root main.tf](lab-guides/lab2-terraform-nac/root-main-tf.md)
3. [NAC YAML File: qos_rocev2.nac.yaml](lab-guides/lab2-terraform-nac/yaml-file.md)
4. [Understanding qos_rocev2.nac.yaml](lab-guides/lab2-terraform-nac/understanding-yaml.md)
5. [NAC Script Integration](lab-guides/lab2-terraform-nac/script-integration.md)
6. [Opening APIC GUI's and applying Terraform Commands](lab-guides/lab2-terraform-nac/apply-terraform.md)

#### [Lab 3: Python Automation](lab-guides/lab3-python/verify-python.md)
1. [Verify Python & Install Dependencies](lab-guides/lab3-python/verify-python.md)
2. [Login to both APIC's](lab-guides/lab3-python/login-apic.md)
3. [Executing the Python Script](lab-guides/lab3-python/execute-script.md)

#### [Lab 4: Bruno API Automation](lab-guides/lab4-bruno/import-collection.md)
1. [Import Collection](lab-guides/lab4-bruno/import-collection.md)
2. [Configure Environment](lab-guides/lab4-bruno/configure-environment.md)
3. [Authentication](lab-guides/lab4-bruno/authentication.md)
4. [Create QoS Policy](lab-guides/lab4-bruno/create-qos-policy.md)

#### [Lab 5: Ansible Playbooks Automation](lab-guides/lab5-ansible/ansible-overview.md)
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

!!! note "Environment Limitations"
    The demonstration environment is a simulated environment and there is no actual data plane, therefore the fabrics will not establish OSPF/BGP adjacency. All configurations will be lost after a reboot of the APIC simulators. A demonstration of this completed configuration in a real environment will be shown at the end with real traffic.

---

## Getting Started

Ready to begin? Start with the [Introduction](introduction/overview.md) to understand the lab environment and objectives.
