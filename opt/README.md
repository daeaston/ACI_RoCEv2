# ACI RoCEv2 QoS Automation

This repository provides an automation-first approach to deploying **RoCEv2 (RDMA over Converged Ethernet v2) Quality of Service policies** on **Cisco ACI fabrics**.

The goal is to demonstrate how lossless Ethernet required for **AI and GPU workloads** can be configured, validated, and reset in a **repeatable, Infrastructure-as-Code (IaC)** manner using multiple automation tools.

This repository is suitable for:
- AI-ready data centre designs
- Multi-fabric ACI environments
- Cisco Live / dCloud lab demonstrations
- Customer proof-of-concept and validation work

---

## 🚀 Key Capabilities

- Automated deployment of RoCEv2 QoS policies (PFC, ECN, WRED)
- Consistent QoS enforcement across one or more ACI fabrics
- Idempotent configuration using Terraform
- API-driven apply and rollback workflows
- Safe reset mechanisms for lab and demo reuse
- Designed for both production patterns and teaching environments

---

## 🧰 Technologies Used

This repository intentionally demonstrates **multiple automation approaches**, allowing engineers to choose the most appropriate tool for their environment:

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
```

## ⚙️ What This Configures

- The automation configures the following RoCEv2-specific QoS components in Cisco ACI:
- Priority queue for RDMA traffic (typically mapped to CoS 3)
- No-drop QoS class with Priority Flow Control (PFC) enabled
- Explicit Congestion Notification (ECN) marking for congestion signalling
- WRED thresholds tuned for RoCEv2 traffic behaviour
- Consistent QoS policy enforcement across one or more ACI fabrics

These components collectively enable lossless Ethernet behaviour required for AI and GPU workloads.

## 🧪 Typical Use Cases

- Validating AI / GPU fabric readiness
- Enforcing QoS consistency across multiple ACI fabrics
- Pre-production testing and safe rollback
- Cisco Live and dCloud lab environments
- Customer demonstrations using real traffic generators

## ▶️ Getting Started (Terraform Example)

# From the Terraform root directory:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

# To remove the configuration and return the fabric to its previous state:

```bash
terraform destroy
```

⚠️ Always review variables and APIC targets before applying changes in shared or production environments.

## 🔁 Reset & Cleanup

For lab, demo, and test environments, the repository includes safe reset and cleanup workflows using:
- Terraform destroy operations
- Python-based APIC REST API reset scripts
- Ansible playbooks for multi-APIC cleanup
This ensures environments can be quickly reused without manual reconfiguration.

## 📘 Documentation

# Detailed walkthroughs and lab guides are provided in:

docs/CiscoLive_RoCEv2_QoS_ACI_Automation.md

# These documents are suitable for:
- Self-paced learning
- Instructor-led workshops
- Cisco Live and customer-facing demonstrations

## ⚠️ Disclaimer

This repository is provided for educational, demonstration, and reference purposes only.
- Always validate configurations in a lab before production deployment
- QoS behaviour may vary depending on ACI software version, hardware platform, and traffic patterns
- No warranties or support commitments are implied

## 👤 Author

David Easton
Cisco Systems – Data Center & AI Networking
