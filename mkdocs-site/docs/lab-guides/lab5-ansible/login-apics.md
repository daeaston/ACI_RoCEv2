# Login to APIC GUIs

Login to each APIC in the same fashion as the previous exercises with each screen showing the Level 2 QoS configuration:

![Ansible](../../assets/images/image013.png)

## Current Configuration (Before Ansible)

You should see the default **Best Effort** configuration:

| Setting | Default Value |
|---------|---------------|
| **Bandwidth** | 20% |
| **Algorithm** | Tail-drop |
| **ECN** | Disabled |
| **PFC Admin State** | No |
| **No-drop CoS** | (empty) |

!!! note "Multiple Browser Tabs"
    Keep both APIC GUI tabs open. After running the Ansible playbook, you can refresh these pages to immediately see the configuration changes applied across both fabrics simultaneously.

## Prepare for Ansible Execution

With both APIC GUIs open showing the QoS configuration, you're ready to execute the Ansible playbooks and observe the automated changes in real-time.

Proceed to [Run Playbooks](../lab5-ansible/run-playbooks.md).
