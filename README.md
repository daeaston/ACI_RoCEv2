Opt Folder – RoCEv2 on Cisco ACI
This opt directory contains multiple automation examples and tools for configuring
RoCEv2 QoS and related ACI policy using different technologies:

Ansible
Terraform (stand‑alone and module‑based)
Python
NAC Terraform example
Postman / Bruno collection
Use this README as a map of what lives where and what each file is for.

Top‑Level Files
README.md
This document. High‑level description of the opt folder layout and usage.
1. Ansible Automation – ansible/
Ansible playbooks and inventory for pushing RoCEv2 QoS‑related changes to ACI.

Files:

ansible/inventory.ini

Ansible inventory file. Defines the APIC/ACI hosts and groups that the playbooks
will target.
ansible/group_vars/apic.yml

Group variables for the APIC hosts defined in inventory.ini.

Typically includes APIC URL, credentials, and common settings (e.g. tenant name,
QoS parameters, etc.).
ansible/playbooks/rocev2_qos.yml

Main playbook to configure RoCEv2 QoS on ACI using Ansible.

Run this to apply the desired QoS configuration.
ansible/playbooks/reset_qos.yml

Playbook to reset or roll back the RoCEv2 QoS settings to a baseline/clean
state.
Typical usage:

bash

cd opt/ansible
ansible-playbook -i inventory.ini playbooks/rocev2_qos.yml
ansible-playbook -i inventory.ini playbooks/reset_qos.yml
2. Bruno / Postman Collection – Bruno/
Pre‑built API workflow for APIC.

File:

Bruno/RoCEv2 ACI - Full Postman Collection.postman_collection.json
A full Postman/Bruno collection for ACI RoCEv2 configuration and verification via REST API calls. Import this into Postman or Bruno to run the sequence of API requests against APIC.
3. NAC Terraform Example – nac/nac-aci-simple-example/
Self‑contained Terraform example that uses NAC‑style YAML data for ACI configuration.

Core files:

nac/nac-aci-simple-example/README.md – readme specific to this example
nac/nac-aci-simple-example/main.tf – main Terraform file
nac/nac-aci-simple-example/.gitignore
nac/nac-aci-simple-example/apic-cookie.txt
Data:

nac/nac-aci-simple-example/data/defaults.nac.yaml
nac/nac-aci-simple-example/data/qos_rocev2.nac.yaml
nac/nac-aci-simple-example/data/tenant_DEV.nac.yaml
Scripts:

nac/nac-aci-simple-example/scripts/reset_qos.sh – resets or removes QoS config
Terraform state & lock files:

.terraform.lock.hcl, terraform.tfstate, terraform.tfstate.backup

4. Python Script – Python/
Python/rocev2_qos.py
Python script for configuring or validating RoCEv2 QoS via the ACI API.
5. Terraform – tf/terraform/
Conventional Terraform layout for ACI / RoCEv2 configuration.

Top‑level files:

main.tf – main Terraform configuration
variables.tf – input variables
LICENSE.txt
apic-cookie.txt
terraform_1.14.0_linux_amd64.zip
scripts/reset_qos.sh
.terraform.lock.hcl
terraform.tfstate
terraform.tfstate.backup
Module – modules/rocev2_qos/:

main.tf – resources implementing the QoS logic
variables.tf – inputs for the module
Providers – .terraform/providers/:

ciscodevnet/aci/... – Cisco ACI provider v2.16.0
hashicorp/null/... – HashiCorp null provider v3.2.4
Example:

bash

cd opt/tf/terraform
terraform init
terraform plan
terraform apply
./scripts/reset_qos.sh
6. General Notes
Credentials & cookies: demo/placeholder only — don’t commit real secrets
Terraform state: prefer remote state for production
Multiple automation paths: choose Ansible, Terraform, Python, or API collections depending on workflow
