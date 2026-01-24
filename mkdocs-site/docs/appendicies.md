# Appendicies

## Appendix A  - Terraform Installation

```bash
[root@centos7-tools1 ~]# wget https://releases.hashicorp.com/terraform/1.14.0/terraform_1.14.0_linux_amd64.zip
--2025-11-24 13:49:51--  https://releases.hashicorp.com/terraform/1.14.0/terraform_1.14.0_linux_amd64.zip
Resolving releases.hashicorp.com (releases.hashicorp.com)... 143.204.68.93, 143.204.68.39, 143.204.68.20, ...
Connecting to releases.hashicorp.com (releases.hashicorp.com)|143.204.68.93|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 30880471 (29M) [application/zip]
Saving to: ‘terraform_1.14.0_linux_amd64.zip’

100%[======================================>] 30,880,471  50.0MB/s   in 0.6s

2025-11-24 13:49:52 (50.0 MB/s) - ‘terraform_1.14.0_linux_amd64.zip’ saved [30880471/30880471]

[root@centos7-tools1 ~]# unzip terraform_1.14.0_linux_amd64.zip
Archive:  terraform_1.14.0_linux_amd64.zip
inflating: LICENSE.txt
inflating: terraform
[root@centos7-tools1 ~]# mv terraform /usr/local/bin/
[root@centos7-tools1 ~]# pwd
/root
[root@centos7-tools1 ~]# cd /usr/local/bin/
[root@centos7-tools1 bin]# ls
git            git-receive-pack    git-upload-pack  minikube
git-cvsserver  git-shell           kubect           terraform
gitk           git-upload-archive  kubectl
[root@centos7-tools1 bin]# cd terraform
-bash: cd: terraform: Not a directory
[root@centos7-tools1 bin]# cd terraform/
-bash: cd: terraform/: Not a directory
[root@centos7-tools1 bin]# terraform --version
Terraform v1.14.0
on linux_amd64
[root@centos7-tools1 bin]#
[root@centos7-tools1 opt]# cd /opt
[root@centos7-tools1 opt]#
```

## Appendix B  - Python Script Explaination

This Python script automates the configuration of RoCEv2 Quality of Service (QoS) on one or more Cisco ACI APIC controllers. It provides two functions:

- Apply a RoCEv2 no-drop QoS policy (WRED + ECN + PFC on CoS 3).
- Reset the QoS policy to default tail-drop behavior.

The script interacts directly with the APIC REST API and supports multiple fabrics by looping through configured APIC URLs.

**Key Python Concepts Used**

- REST API calls using the requests library
- XML payload submission to APIC managed object (MO) endpoints
- Command-line argument handling
- Session cookie authentication
- Per-APIC error handling

**Basic Script Configuration**

**Credential Definitions**
- APIC username and password defined at the top of the script.
- Replaced by secure storage in production.

**APIC URL List**
- A list of target APIC endpoints enabling multi-fabric execution.

**APIC Login Function (login())**
- Authenticates to an APIC and retrieves the session cookie for API operations.

**How It Works**
- Posts credentials to /api/aaaLogin.json.
- Returns the APIC session cookie or fails authentication.

**Role in the Script**
- Each APIC must authenticate before configuration changes.

**Applying the RoCEv2 QoS Policy (apply_rocev2_qos())**

**Objective**

Configures class-level2 QoS to support RoCEv2 no-drop traffic using:
- Priority Flow Control (PFC)
- WRED congestion management
- Explicit Congestion Notification (ECN)

**Key Configuration Elements in the XML Payload**
- QoS Class (qosClass) targeting class-level2.
- Congestion Policy (qosCong) with WRED and ECN enabled.
- PFC Policy (qosPfcPol) assigning CoS 3 as no-drop.

**API Interaction**
- Posts XML to /api/node/mo/uni.xml.
- Uses the APIC session cookie.
- Raises errors if rejected.

**Destroying the RoCEv2 QoS Policy (destroy_rocev2_qos())**

**Purpose**
- Restores class-level2 QoS to default behavior.

**Reset Actions Performed**
- Reverts congestion handling to tail-drop
- Disables ECN and PFC
- Clears no-drop CoS settings

**When It’s Used**
- Lab cleanup
- Undoing Terraform deployments
- Preparing a clean environment

**Command-Line Control**
The script expects one of the following arguments:
- apply – ‘python rocev2_qos.py apply’
- destroy – ‘python rocev2_qos.py destroy’

**Main Execution Loop**
For each APIC:
- Authenticate using login().
- Perform the selected action.
- Log errors without stopping execution.
This ensures failures on one fabric do not impact others.

**Benefits of This Script**
- Rapid, repeatable QoS deployment across fabrics.
- Consistent RoCEv2 configuration.
- Clear separation between apply and teardown workflows.
- Human-readable XML aligned with the APIC object model.

**Summary**
This Python tool provides a lightweight method to configure and reset RoCEv2 QoS policies across Cisco ACI fabrics for labs, demos, and repeatable testing.

## Appendix C  - Reference to all links

- [ACI Policy Model Guide](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/policy-model-guide/b-Cisco-ACI-Policy-Model-Guide.html)
- [Cisco APIC and QoS](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/kb/Cisco-APIC-and-QoS.html)
- [ACI RoCEv2 Settings](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/kb/Cisco-APIC-and-QoS.html#id_77213)
- [Wikipedia RoCE Description](https://en.wikipedia.org/wiki/RDMA_over_Converged_Ethernet?utm_source=chatgpt.com)
- [Youtube Video describing RoCEv2](https://www.youtube.com/watch?v=nKz92Yr09q8)
- [ACI Policy Model Guide](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/policy-model-guide/b-Cisco-ACI-Policy-Model-Guide.html)
- [Terraform ACI Provider Documentation](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs)
- [Terraform Introduction](https://developer.hashicorp.com/terraform/intro) 
- [ACI Terraform Provider](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs) 
- [ACI Terraform QoS Documentation](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/qos_instance_policy) 
- [ACI Modules Terraform Registry](https://registry.terraform.io/providers/CiscoDevNet/aci/latest) 
- [Devnet Lab on Terraform for ACI](https://developer.cisco.com/learning/search/?contentType=lab&page=1) 
- [Video on Tarraform & Ansible Programmability](https://video.cisco.com/detail/video/6371473476112)
- [Cisco Netascode Site](https://netascode.cisco.com/)
- [Netascode ACI Section](https://netascode.cisco.com/docs/start/aci/introduction/)
- [Netascode Data Models Programmability](https://netascode.cisco.com/docs/data_models/)
- [Netascode ACI QoS](https://netascode.cisco.com/docs/data_models/apic/access_policies/qos/)
- [Python ACI SDK (Cobra)](https://cobra.readthedocs.io/)
- [Cisco ACI Python SDK Documentation](https://cobra.readthedocs.io/en/latest/)
- [Devnet Python ACI Examples](https://developer.cisco.com/codeexchange/github/repo/CiscoDevNet/python_code_samples_network/)
- [Github Python ACI Examples](https://github.com/CiscoDevNet/aci-learning-labs-code-samples)
- [Ansible ACI Community Documentation](https://docs.ansible.com/projects/ansible/9/scenario_guides/guide_aci.html)
- [ACI Ansible Plugins Collection](https://docs.ansible.com/projects/ansible/latest/collections/cisco/aci/#plugin-index)
- [ACI Ansible Github Repository](https://github.com/CiscoDevNet/ansible-aci)
- [Devnet Ansible ACI Lab](https://developer.cisco.com/learning/labs/aci_ansible_part3/create-a-single-playbook/)
- [Ansible Galaxy ACI Documentation](https://galaxy.ansible.com/ui/repo/published/cisco/aci/)