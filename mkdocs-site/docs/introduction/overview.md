# Introduction to Lab

This comprehensive lab manual provides a structured, end-to-end workshop for configuring and automating RoCEv2 QoS across ACI fabrics. It leverages a multi-workflow approach, demonstrating automation using Terraform (Custom modules and Netascode NAC), Python, Bruno, and Ansible:

[ACI Policy Model Guide](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/policy-model-guide/b-Cisco-ACI-Policy-Model-Guide.html)

This guide is designed for Cisco Live DevNet, dCloud, CPOC, or customer-facing training environments, aiming to equip participants with practical skills for building modern, lossless AI-ready transport environments.

!!! warning "Limitations"
    The demonstration environment is a simulated environment and there is no actual data plane, therefore the fabrics will not establish OSPF/BGP adjacency. All configurations will be lost after a reboot of the APIC simulators. A demonstration of this completed configuration in a real environment will be shown at the end with real traffic.

---

## Lab Outcomes & Objectives

Upon completing this lab, participants will be able to:

- Understand RoCEv2 QoS concepts, including WRED, ECN, PFC, and Class of Service (CoS) mapping.
- Build Terraform root and child modules from scratch for ACI configuration.
- Validate configuration changes within the APIC GUI.
- Compare and contrast manual Terraform configuration with NAC-driven Terraform.
- Execute cross-tool automation workflows using Python, Bruno, and Ansible.
- Reinforce automation repeatability across dual-fabric environments.

---

This environment mimics a dual-fabric deployment, frequently utilized for AI workloads requiring robust RoCEv2 QoS.

## Next Steps

Proceed to [RoCEv2 Explained](../introduction/rocev2-explained.md)
