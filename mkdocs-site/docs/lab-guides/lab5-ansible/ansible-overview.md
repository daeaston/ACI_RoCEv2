# Lab 5: Ansible Playbooks Automation

## Introduction

![Ansible](../../assets/images/image041.png)

Ansible is an agentless automation tool used for configuration, orchestration, and operational tasks across infrastructure and networks. It uses human-readable YAML playbooks and connects over standard protocols such as SSH or HTTPS, avoiding the need for agents. Ansible is particularly strong for day-0 and day-2 operations where execution order, conditions, and error handling matter.

Compared to Terraform, Ansible provides more procedural control. While Terraform focuses on declarative provisioning and state management, Ansible allows engineers to define step-by-step workflows, making it well suited to brownfield or operationally complex environments. The two tools are often used together, with Ansible complementing Terraform's lifecycle management:

## Terraform vs Ansible Comparison

| Feature | Terraform | Ansible |
|---------|-----------|---------|
| **Automation Style** | Declarative | Procedural |
| **Primary Focus** | Provisioning & state | Configuration & operations |
| **State Management** | Built-in state file | No persistent state |
| **Execution Model** | Desired end state | Step-by-step tasks |
| **Strengths** | Repeatability, drift control | Sequencing, logic, remediation |
| **Best Fit** | Day-0 provisioning | Day-1 / Day-2 operations |

## Ansible Galaxy and ACI Support

Ansible Galaxy is the ecosystem for sharing reusable automation content such as roles and collections. Vendors like Cisco publish supported collections (for example, `cisco.aci`), allowing teams to automate platforms such as ACI quickly and consistently without building everything from scratch.

### Useful Resources

- [Ansible ACI Community Documentation](https://docs.ansible.com/projects/ansible/9/scenario_guides/guide_aci.html)
- [ACI Ansible Plugins Collection](https://docs.ansible.com/projects/ansible/latest/collections/cisco/aci/#plugin-index)
- [ACI Ansible Github Repository](https://github.com/CiscoDevNet/ansible-aci)
- [Devnet Ansible ACI Lab](https://developer.cisco.com/learning/labs/aci_ansible_part3/create-a-single-playbook/)
- [Ansible Galaxy ACI Documentation](https://galaxy.ansible.com/ui/repo/published/cisco/aci/)

## What You'll Learn

This section details the use of Ansible playbooks to automate the application and resetting of RoCEv2 QoS configurations across multiple APIC fabrics.

In this lab, you will:

- Set up an Ansible directory structure
- Create inventory files for multiple APIC controllers
- Define variables for APIC credentials and connection details
- Write playbooks to apply RoCEv2 QoS configuration
- Write playbooks to reset QoS to default settings
- Execute playbooks across multiple APIC fabrics simultaneously

Proceed to [Setup Directory Structure](../lab5-ansible/setup-directory.md).
