# Create Apply QoS Playbook

## About This Playbook

The `rocev2_qos.yml` playbook applies RoCEv2 QoS configuration to the APIC controllers. It configures:

- **WRED** (Weighted Random Early Detection) congestion control
- **ECN** (Explicit Congestion Notification) enabled
- **PFC** (Priority Flow Control) on CoS 3
- **60% bandwidth allocation** for Level 2 traffic

## Navigate to Playbooks Directory

- Navigate to the playbooks directory:

```bash
cd ..
cd playbooks/
```

## Create the Playbook

- Create the `rocev2_qos.yml` playbook by executing `vi rocev2_qos.yml` and pasting the following content:

```bash
vi rocev2_qos.yml
```

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

## Playbook Content

```yaml
---
- name: Apply RoCEv2 QoS Config to ACI
  hosts: apic
  gather_facts: no

  tasks:
    - name: Login to APIC and retrieve cookie
      uri:
        url: "{{ apic_url }}/api/aaaLogin.json"
        method: POST
        body_format: json
        headers:
          Content-Type: application/json
        body:
          aaaUser:
            attributes:
              name: "{{ apic_username }}"
              pwd: "{{ apic_password }}"
        return_content: yes
        status_code: 200
        validate_certs: no
      register: login_response

    - name: Extract APIC auth cookie
      set_fact:
        apic_cookie: "{{ login_response.cookies['APIC-cookie'] }}"

    - name: Configure QoS Class Level2 for RoCEv2
      uri:
        url: "{{ apic_url }}/api/node/mo/uni.xml"
        method: POST
        headers:
          Content-Type: application/xml
          Cookie: "APIC-cookie={{ apic_cookie }}"
        body: |
          <qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
            <qosCong algo="wred" wredMinThreshold="40" wredMaxThreshold="60" wredProbability="10" ecn="enabled" forwardNonEcn="enabled"/>
            <qosPfcPol name="default" noDropCos="cos3" adminSt="yes" enableScope="fabric"/>
            <qosSched bw="60"/>
          </qosClass>
        body_format: raw
        status_code: 200
        validate_certs: no

```

## Save the File

- Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

- Once outside the vi editor, the file can be verified by typing:

```bash
cat rocev2_qos.yml
```

## Understanding the Playbook

### Play Definition
```yaml
- name: Apply RoCEv2 QoS Config to ACI
  hosts: apic
  gather_facts: no
```
- Runs against all hosts in the `[apic]` group
- Disables fact gathering for faster execution

### Task 1: Authentication
```yaml
- name: Login to APIC and retrieve cookie
  uri:
    url: "{{ apic_url }}/api/aaaLogin.json"
    ...
  register: login_response
```
- Authenticates to the APIC using REST API
- Stores the response (including authentication cookie) in `login_response`

### Task 2: Extract Cookie
```yaml
- name: Extract APIC auth cookie
  set_fact:
    apic_cookie: "{{ login_response.cookies['APIC-cookie'] }}"
```
- Extracts the authentication cookie from the login response
- Stores it as a fact for use in subsequent tasks

### Task 3: Configure QoS
```yaml
- name: Configure QoS Class Level2 for RoCEv2
  uri:
    url: "{{ apic_url }}/api/node/mo/uni.xml"
    ...
    body: |
      <qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
        ...
      </qosClass>
```
- Sends XML payload to configure QoS settings
- Uses the authentication cookie from the previous task
- Configures WRED, ECN, PFC, and bandwidth allocation

## QoS Configuration Details

| Setting | Value | Purpose |
|---------|-------|---------|
| **Algorithm** | WRED | Weighted Random Early Detection for congestion |
| **WRED Min** | 40% | Minimum threshold before packet dropping starts |
| **WRED Max** | 60% | Maximum threshold for full dropping |
| **ECN** | Enabled | Explicit Congestion Notification |
| **PFC CoS** | CoS 3 | Priority Flow Control on Class of Service 3 |
| **Bandwidth** | 60% | Guaranteed bandwidth for Level 2 traffic |

Proceed to [Reset QoS Playbook](../lab5-ansible/reset-qos-playbook.md).


