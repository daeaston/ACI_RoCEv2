# RoCEv2 QoS Automation for Cisco ACI

This repository provides a complete, automation-first approach to deploying **RoCEv2 (RDMA over Converged Ethernet v2) Quality of Service policies** on **Cisco ACI fabrics**.

The project demonstrates how lossless Ethernet for AI and GPU workloads can be configured, validated, and reset **consistently and repeatably** using Infrastructure-as-Code (IaC) and API-driven tools.

It is designed for **AI-ready data centres**, **multi-fabric environments**, and **Cisco Live / customer demo scenarios**.

---

## 🚀 Key Capabilities

- Automated deployment of RoCEv2 QoS policies (No-Drop, ECN, WRED, PFC)
- Support for single or multiple ACI fabrics
- Idempotent configuration using Terraform
- API-level control for apply and rollback
- Safe reset / destroy workflows for lab and demo environments
- Suitable for production, PoC, and Cisco Live labs

---

## 🧰 Technologies Used

This repository intentionally demonstrates multiple automation approaches, allowing engineers to choose the right tool for their environment:

- **Terraform (Custom Modules)** – Direct APIC REST-based configuration
- **Terraform (Netascode NAC)** – Declarative, YAML-driven ACI policy management
- **Python** – Direct APIC REST API scripting for apply and cleanup
- **Ansible** – Multi-APIC orchestration and reset workflows
- **Bruno / API Clients** – Manual and automated REST API testing
- **Nexus Dashboard** – Telemetry and traffic behaviour visualisation (optional)

---

## 📁 Repository Structure

```text
.
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── providers.tf
│   └── modules/
│       └── rocev2_qos/
│           └── main.tf
│
├── nac/
│   └── rocev2_qos.yaml
│
├── python/
│   └── rocev2_qos.py
│
├── ansible/
│   ├── apply_qos.yml
│   └── reset_qos.yml
│
├── docs/
│   └── CiscoLive_RoCEv2_QoS_ACI_Automation.md


│
└── README.md

---

