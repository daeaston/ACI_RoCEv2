# Prerequisites

Before beginning this workshop, participants should have:

## Knowledge Prerequisites

**Basic Networking Concepts**
- Understanding of Layer 2/Layer 3 networking
- Familiarity with Ethernet and IP protocols
- Knowledge of QoS concepts
    

**Cisco ACI Familiarity**
- Basic understanding of ACI architecture
- Familiarity with APIC GUI navigation
- Understanding of ACI policy model (Tenants, Application Profiles, EPGs)
    

**Automation Experience**
- Basic command-line proficiency (Linux/Unix)
- Understanding of Infrastructure as Code (IaC) concepts
- Familiarity with at least one of: Terraform, Python, or REST APIs

## Software Requirements

The lab environment provides all necessary software pre-installed:

- **Terraform 1.14.0** (will be installed in Lab 1)
- **Python 3.11.1** with pip package manager
- **Bruno 3.0.2** API client
- **Ansible 2.8.1** alternative to Terraform
- **ACI 5.2(7f)** (The Demo at the end uses 6.1(4h))

## Optional Resources

- [ACI Policy Model Guide](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/policy-model-guide/b-Cisco-ACI-Policy-Model-Guide.html)
- [Terraform ACI Provider Documentation](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs)
- [Python ACI SDK (Cobra)](https://cobra.readthedocs.io/)

## Estimated Time

- **Total Workshop Duration:** 70 minutes
- **Lab 1 Terraform Classic:** 20 minutes
- **Lab 2 Terraform NAC:** 15 minutes
- **Lab 3 Python:** 10 minutes
- **Lab 4 Bruno API:** 10 minutes
- **Lab 5 Ansible Playbooks:** 15 minutes

!!! tip "Lab Flexibility"
    Each lab is self-contained. You can complete them in order or jump to specific sections based on your interests and time availability. Doing the Terraform Custom module first

## Next Steps

Proceed to [Getting started](../introduction/getting-started.md).
