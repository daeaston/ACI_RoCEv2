# Create Reset QoS Playbook

## About This Playbook

The `reset_qos.yml` playbook resets QoS configuration back to default settings on the APIC controllers. It configures:

- **Tail-drop** congestion control (disables WRED)
- **ECN disabled**
- **PFC disabled**
- **20% bandwidth allocation** for Level 2 traffic (default)

This playbook is useful for cleanup or returning to baseline configuration.

## Create the Playbook

Create the `reset_qos.yml` playbook by executing `vi reset_qos.yml` and pasting the following content:

```bash
vi reset_qos.yml
```

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

## Playbook Content

```yaml
---
- name: Reset RoCEv2 QoS Config to Default
  hosts: apic
  gather_facts: no
  vars_files:
    - ../group_vars/apic.yml

  tasks:
    - name: Login to APIC and retrieve cookie
      uri:
        url: "{{ apic_url }}/api/aaaLogin.json"
        method: POST
        headers:
          Content-Type: application/json
        body: >
          {
            "aaaUser": {
              "attributes": {
                "name": "{{ apic_username }}",
                "pwd": "{{ apic_password }}"
              }
            }
          }
        body_format: json
        return_content: yes
        status_code: 200
        validate_certs: no
      register: login_response

    - name: Extract APIC cookie
      set_fact:
        apic_cookie: "{{ login_response.set_cookie }}"

    - name: Reset QoS Level2 config (Tail-drop, PFC disabled)
      uri:
        url: "{{ apic_url }}/api/node/mo/uni.xml"
        method: POST
        headers:
          Content-Type: application/xml
          Cookie: "{{ apic_cookie }}"
        body: |
          <qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
            <qosCong algo="tail-drop" ecn="disabled" forwardNonEcn="disabled"/>
            <qosPfcPol name="default" adminSt="no" noDropCos="" enableScope="fabric"/>
            <qosSched bw="20"/>
          </qosClass>
        body_format: raw
        status_code: 200
        validate_certs: no

```

## Save the File

Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

Once outside the vi editor, the file can be verified by typing:

```bash
cat reset_qos.yml
```

## Understanding the Playbook

### Play Definition
```yaml
- name: Reset RoCEv2 QoS Config to Default
  hosts: apic
  gather_facts: no
  vars_files:
    - ../group_vars/apic.yml
```
- Runs against all hosts in the `[apic]` group
- Explicitly loads the group variables file
- Disables fact gathering for faster execution

### Task 1: Authentication
Similar to the apply playbook, authenticates to the APIC and retrieves a session cookie.

### Task 2: Extract Cookie
Extracts the authentication cookie for use in API calls.

### Task 3: Reset QoS Configuration
```yaml
- name: Reset QoS Level2 config (Tail-drop, PFC disabled)
  uri:
    ...
    body: |
      <qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
        <qosCong algo="tail-drop" ecn="disabled" forwardNonEcn="disabled"/>
        <qosPfcPol name="default" adminSt="no" noDropCos="" enableScope="fabric"/>
        <qosSched bw="20"/>
      </qosClass>
```
- Sends XML payload to reset QoS to default settings
- Disables advanced features like WRED, ECN, and PFC
- Returns bandwidth allocation to 20%

## Default QoS Configuration

| Setting | Default Value | Purpose |
|---------|---------------|---------|
| **Algorithm** | Tail-drop | Simple drop when queue is full |
| **ECN** | Disabled | No explicit congestion notification |
| **PFC** | Disabled | No priority flow control |
| **Bandwidth** | 20% | Default bandwidth for Level 2 traffic |

## Comparison: Apply vs Reset

| Feature | Apply QoS | Reset QoS |
|---------|-----------|-----------|
| Congestion Control | WRED (40-60%) | Tail-drop |
| ECN | Enabled | Disabled |
| PFC | Enabled (CoS 3) | Disabled |
| Bandwidth | 60% | 20% |
| Use Case | RoCEv2 optimization | Return to defaults |

Proceed to [Login to APICs](../lab5-ansible/login-apics.md).
