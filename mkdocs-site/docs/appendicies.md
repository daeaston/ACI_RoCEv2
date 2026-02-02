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

Full Python Script is below:

```python
import requests

# ---------------------------------------------------------------------------
# Basic configuration
# ---------------------------------------------------------------------------

# Credentials used to authenticate to each Cisco ACI APIC.
# In production, avoid hard-coding these and consider using environment
# variables, a secrets manager, or a config file instead.
USERNAME = "admin"
PASSWORD = "C1sco12345"

# List of APIC URLs that this script will operate on.
# The script will log in and apply/destroy QoS config on *each* APIC in turn.
APIC_URLS = [
    "https://apic1-a.corp.pseudoco.com",
    "https://apic1-b.corp.pseudoco.com"
]

# ---------------------------------------------------------------------------
# APIC login helper
# ---------------------------------------------------------------------------

def login(apic_url):
    """
    Log into the APIC and return the APIC session cookie.

    The APIC uses a token-based session cookie (\"APIC-cookie\") that must be
    sent with subsequent API calls in order to authenticate those requests.
    """
    print(f"Logging in to {apic_url}...")

    url = f"{apic_url}/api/aaaLogin.json"

    payload = {
        "aaaUser": {
            "attributes": {
                "name": USERNAME,
                "pwd": PASSWORD
            }
        }
    }

    response = requests.post(url, json=payload, verify=False)
    response.raise_for_status()

    cookie = response.cookies.get("APIC-cookie")
    print("Login successful.")
    return cookie

# ---------------------------------------------------------------------------
# Apply RoCEv2 QoS policy
# ---------------------------------------------------------------------------

def apply_rocev2_qos(apic_url, cookie):
    """
    Apply a RoCEv2-oriented QoS configuration on the APIC.
    """
    print(f"Applying RoCEv2 QoS configuration on {apic_url}...")

    url = f"{apic_url}/api/node/mo/uni.xml"
    headers = {"Content-Type": "application/xml"}

    data = """<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
  <qosCong algo="wred" wredMaxThreshold="60" wredMinThreshold="40" wredProbability="0" ecn="enabled" forwardNonEcn="enabled"/>
  <qosPfcPol name="default" noDropCos="cos3" adminSt="yes" enableScope="fabric"/>
  <qosSched bw="60"/>
</qosClass>"""

    response = requests.post(
        url,
        headers=headers,
        data=data,
        cookies={"APIC-cookie": cookie},
        verify=False
    )

    print("Response:", response.text)
    response.raise_for_status()

    print("QoS configuration applied successfully.")

# ---------------------------------------------------------------------------
# Destroy / reset RoCEv2 QoS policy
# ---------------------------------------------------------------------------

def destroy_rocev2_qos(apic_url, cookie):
    """
    Reset the QoS configuration for the RoCEv2 class.
    """
    print(f"Tearing down RoCEv2 QoS configuration on {apic_url}...")

    url = f"{apic_url}/api/node/mo/uni.xml"
    headers = {"Content-Type": "application/xml"}

    data = """<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
  <qosCong algo="tail-drop" ecn="disabled" forwardNonEcn="disabled"/>
  <qosPfcPol name="default" adminSt="no" noDropCos="" enableScope="fabric"/>
  <qosSched bw="20"/>
</qosClass>"""

    response = requests.post(
        url,
        headers=headers,
        data=data,
        cookies={"APIC-cookie": cookie},
        verify=False
    )

    print("Response:", response.text)
    response.raise_for_status()

    print("QoS configuration removed successfully.")

# ---------------------------------------------------------------------------
# Script entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2 or sys.argv[1] not in {"apply", "destroy"}:
        print("Usage: python rocev2_qos.py apply|destroy")
        exit(1)

    action = sys.argv[1]

    for apic_url in APIC_URLS:
        try:
            session_cookie = login(apic_url)

            if action == "apply":
                apply_rocev2_qos(apic_url, session_cookie)
            else:
                destroy_rocev2_qos(apic_url, session_cookie)
        except Exception as e:
            print(f"Error on {apic_url}: {e}")
```

## Appendix C  - Bruno .json Script Explaination

This Bruno/Postman collection automates the configuration of RoCEv2 Quality of Service (QoS) on Cisco ACI APIC controllers through a REST API interface. It provides three sequential API operations:

1. Authenticate to the APIC and obtain a session token.
2. Apply a RoCEv2 no-drop QoS policy (WRED + ECN + PFC on CoS 3).
3. Reset the QoS policy to default tail-drop behavior.

The collection uses environment variables for flexible deployment and automatically captures authentication tokens for subsequent requests.

Key API Concepts Used

- RESTful API authentication using JSON payloads
- Session-based authentication with APIC-cookie token management
- XML payload submission for QoS configuration
- Collection variables for token persistence across requests
- Postman/Bruno test scripts for automated token extraction
- Reusable base URL configuration for multi-fabric deployments

Basic Collection Configuration

Collection Variables

- **APIC-cookie**: Stores the session authentication token (automatically populated)
- **base_url**: The target APIC controller URL (e.g., `https://apic1-a.corp.pseudoco.com`)

These variables enable the collection to be reused across multiple APIC fabrics by simply updating the base_url.

Request 1: Login to APIC (login())

Objective

Authenticates to the APIC controller and retrieves a session token for subsequent API operations.

How It Works

- **Method**: POST
- **Endpoint**: `{{base_url}}/api/aaaLogin.json`
- **Content-Type**: application/json
- **Payload Structure**:
  ```json
  {
    "aaaUser": {
      "attributes": {
        "name": "admin",
        "pwd": "C1sco12345"
      }
    }
  }
  ```

Authentication Process

1. Sends credentials in JSON format to the APIC login endpoint.
2. APIC validates credentials and returns a session token.
3. The test script automatically extracts the token from the response.
4. Token is stored in the `APIC-cookie` collection variable.

Test Script Functionality

The embedded JavaScript test script performs automated token extraction:

```javascript
var jsonData = pm.response.json();
var token = jsonData.imdata[0].aaaLogin.attributes.token;
pm.collectionVariables.set("APIC-cookie", token);
```

This eliminates manual token copying and enables seamless API workflow automation.

Role in the Collection

All subsequent requests depend on this authentication step. The captured token is automatically injected into subsequent request headers via the `{{APIC-cookie}}` variable.

Request 2: Apply RoCEv2 QoS Config (apply_rocev2_qos())

Objective

Configures class-level2 QoS to support RoCEv2 no-drop traffic using:

- Priority Flow Control (PFC)
- WRED congestion management
- Explicit Congestion Notification (ECN)

How It Works

- **Method**: POST
- **Endpoint**: `{{base_url}}/api/node/mo/uni/infra/qosinst-default/class-level2.xml`
- **Content-Type**: application/xml
- **Authentication**: Cookie header with `APIC-cookie={{APIC-cookie}}`

Key Configuration Elements in the XML Payload

```xml
<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
  <qosCong algo="wred" wredMaxThreshold="60" wredMinThreshold="40" wredProbability="0" ecn="enabled" forwardNonEcn="enabled"/>
  <qosPfcPol name="default" noDropCos="cos3" adminSt="yes" enableScope="fabric"/>
  <qosSched bw="60"/>
</qosClass>
```

Configuration Breakdown

- **qosClass**: Targets class-level2 for RoCEv2 traffic
  - `admin="enabled"`: Activates the QoS class
  - `prio="level2"`: Sets priority level
  
- **qosCong**: Configures congestion management
  - `algo="wred"`: Enables Weighted Random Early Detection
  - `wredMaxThreshold="60"`: Maximum queue depth before aggressive dropping
  - `wredMinThreshold="40"`: Minimum queue depth before probabilistic dropping
  - `ecn="enabled"`: Activates Explicit Congestion Notification
  - `forwardNonEcn="enabled"`: Forwards non-ECN capable traffic

- **qosPfcPol**: Configures Priority Flow Control
  - `noDropCos="cos3"`: Designates CoS 3 as no-drop traffic class
  - `adminSt="yes"`: Enables PFC globally
  - `enableScope="fabric"`: Applies policy fabric-wide

- **qosSched**: Allocates bandwidth
  - `bw="60"`: Reserves 60% bandwidth for class-level2

API Interaction

The request posts XML directly to the APIC managed object (MO) endpoint, using the session cookie for authentication. The APIC validates the configuration and applies it across the fabric.

Request 3: Reset RoCEv2 QoS Config (destroy_rocev2_qos())

Purpose

Restores class-level2 QoS to default behavior, effectively disabling RoCEv2 optimizations.

How It Works

- **Method**: POST
- **Endpoint**: `{{base_url}}/api/node/mo/uni/infra/qosinst-default/class-level2.xml`
- **Content-Type**: application/xml
- **Authentication**: Cookie header with `APIC-cookie={{APIC-cookie}}`

Reset Configuration XML

```xml
<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
  <qosCong algo="tail-drop" ecn="disabled" forwardNonEcn="disabled"/>
  <qosPfcPol name="default" noDropCos="" adminSt="no" enableScope="fabric"/>
  <qosSched bw="20"/>
</qosClass>
```

Reset Actions Performed

- **Congestion Management**: Reverts to tail-drop (simple queue management)
- **ECN**: Disabled (`ecn="disabled"`)
- **PFC**: Disabled globally (`adminSt="no"`)
- **No-Drop CoS**: Cleared (`noDropCos=""`)
- **Bandwidth Allocation**: Reset to default 20%

When It's Used

- Lab cleanup after demonstrations
- Undoing Terraform or automation deployments
- Preparing a clean environment for baseline testing
- Troubleshooting RoCEv2 issues by reverting to defaults

Collection Workflow

Typical Execution Sequence

1. **Update Environment**: Set `base_url` to target APIC controller
2. **Run Login Request**: Authenticates and captures token automatically
3. **Run Apply Request**: Configures RoCEv2 QoS policy
4. **Run Reset Request**: (Optional) Reverts to default configuration

The collection is designed for sequential execution, with each request building on the previous step's output.

Multi-Fabric Deployment

To apply the same configuration across multiple fabrics:

1. Update the `base_url` variable to point to the next APIC
2. Re-run the three requests in sequence
3. The login step automatically refreshes the authentication token

This eliminates the need for multiple collection copies or manual token management.

Benefits of This Collection

- **Single-Click Authentication**: Automated token capture eliminates manual copying
- **Reusable Configuration**: Base URL variable enables multi-fabric deployment
- **Idempotent Operations**: Apply and reset can be run multiple times safely
- **Human-Readable XML**: Configuration payloads are easy to audit and modify
- **Zero Code Required**: Pure REST API calls without scripting dependencies
- **Version Controlled**: JSON format integrates with Git workflows
- **Tool Agnostic**: Works in both Postman and Bruno clients

Comparison with Python Script

| Aspect | Bruno Collection | Python Script |
|--------|-----------------|---------------|
| **Execution** | Manual (GUI-based) | Automated (CLI-based) |
| **Multi-Fabric** | Manual base_url update | Automatic loop through APIC_URLS |
| **Error Handling** | Manual inspection | Try-catch per APIC |
| **Authentication** | Per-collection run | Per-APIC in loop |
| **Best For** | Interactive testing, learning | Automation, CI/CD pipelines |

The Bruno collection excels at manual configuration and testing, while the Python script is optimized for automated deployments across multiple fabrics.

Summary

This Bruno/Postman collection provides a lightweight, GUI-based method to configure and reset RoCEv2 QoS policies on Cisco ACI fabrics. It uses standard REST API calls with automated token management, making it ideal for labs, demonstrations, and interactive testing scenarios.

```json
{
	"info": {
		"_postman_id": "f13634bb-f39c-4eda-b784-f6ad4b534e78",
		"name": "RoCEv2 ACI - Full Postman Collection",
		"schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
		"_exporter_id": "1098931"
	},
	"item": [
		{
			"name": "1) Login to APIC",
			"event": [
				{
					"listen": "test",
					"script": {
						"exec": [
							"var jsonData = pm.response.json();",
							"var token = jsonData.imdata[0].aaaLogin.attributes.token;",
							"pm.collectionVariables.set(\"APIC-cookie\", token);"
						],
						"type": "text/javascript",
						"packages": {}
					}
				}
			],
			"request": {
				"method": "POST",
				"header": [
					{
						"key": "Content-Type",
						"value": "application/json"
					}
				],
				"body": {
					"mode": "raw",
					"raw": "{\n  \"aaaUser\": {\n    \"attributes\": {\n      \"name\": \"admin\",\n      \"pwd\": \"C1sco12345\"\n    }\n  }\n}"
				},
				"url": {
					"raw": "{{base_url}}/api/aaaLogin.json",
					"host": [
						"{{base_url}}"
					],
					"path": [
						"api",
						"aaaLogin.json"
					]
				}
			},
			"response": []
		},
		{
			"name": "2) Apply RoCEv2 QoS Config",
			"request": {
				"method": "POST",
				"header": [
					{
						"key": "Content-Type",
						"value": "application/xml"
					},
					{
						"key": "Cookie",
						"value": "APIC-cookie={{APIC-cookie}}"
					}
				],
				"body": {
					"mode": "raw",
					"raw": "<qosClass admin=\"enabled\" dn=\"uni/infra/qosinst-default/class-level2\" prio=\"level2\">\n  <qosCong algo=\"wred\" wredMaxThreshold=\"60\" wredMinThreshold=\"40\" wredProbability=\"0\" ecn=\"enabled\" forwardNonEcn=\"enabled\"/>\n  <qosPfcPol name=\"default\" noDropCos=\"cos3\" adminSt=\"yes\" enableScope=\"fabric\"/>\n <qosSched bw=\"60\"/>\n</qosClass>"
				},
				"url": {
					"raw": "{{base_url}}/api/node/mo/uni/infra/qosinst-default/class-level2.xml",
					"host": [
						"{{base_url}}"
					],
					"path": [
						"api",
						"node",
						"mo",
						"uni",
						"infra",
						"qosinst-default",
						"class-level2.xml"
					]
				}
			},
			"response": []
		},
		{
			"name": "3) Reset RoCEv2 QoS Config",
			"request": {
				"method": "POST",
				"header": [
					{
						"key": "Content-Type",
						"value": "application/xml"
					},
					{
						"key": "Cookie",
						"value": "APIC-cookie={{APIC-cookie}}"
					}
				],
				"body": {
					"mode": "raw",
					"raw": "<qosClass admin=\"enabled\" dn=\"uni/infra/qosinst-default/class-level2\" prio=\"level2\">\r\n  <qosCong algo=\"tail-drop\" ecn=\"disabled\" forwardNonEcn=\"disabled\"/>\r\n  <qosPfcPol name=\"default\" noDropCos=\"\" adminSt=\"no\" enableScope=\"fabric\"/>\r\n  <qosSched bw=\"20\"/>\r\n</qosClass>",
					"options": {
						"raw": {
							"language": "json"
						}
					}
				},
				"url": {
					"raw": "{{base_url}}/api/node/mo/uni/infra/qosinst-default/class-level2.xml",
					"host": [
						"{{base_url}}"
					],
					"path": [
						"api",
						"node",
						"mo",
						"uni",
						"infra",
						"qosinst-default",
						"class-level2.xml"
					]
				}
			},
			"response": []
		}
	],
	"variable": [
		{
			"key": "APIC-cookie",
			"value": ""
		}
	]
}
```

## Appendix D  - Reference to all links

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

Return back to the [Homepage](index.md)
