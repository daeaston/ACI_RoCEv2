# Login to APIC GUIs

Open both APIC Simulators

- Open Chrome Browser on the Desktop of the Windows Machine
- Click on shortcuts to each APIC: ‘APIC-SF’ and ‘APIC-NY’ with separate Tabs for each
- Login to each APIC via admin/C1sco12345

![Apic Simulators](../../assets/images/image009.png)

- From each APIC, navigate to **Fabric -> Access Policies -> Policies -> Global -> QOS Class -> Level2**, where the default **‘Best Effort’** QoS settings will then be displayed on the right:

![Access Policies](../../assets/images/image044.png)

- (Optional) – Right Click on one of the Browser Tabs and select ‘Add tab to new split view’ to get the view of both APIC’s:

![Split View](../../assets/images/image048.png)

![Split View](../../assets/images/image042.png)

!!! note "Multiple Browser Tabs"
    Keep both APIC GUI tabs open. After running the Ansible playbook, you can immediately see the configuration changes applied across both fabrics simultaneously.

## Current Configuration (Before Ansible)

You should see the default **Best Effort** configuration:

| Setting | Default Value |
|---------|---------------|
| **Bandwidth** | 20% |
| **Algorithm** | Tail-drop |
| **ECN** | Disabled |
| **PFC Admin State** | No |
| **No-drop CoS** | (empty) |

## Prepare for Ansible Execution

With both APIC GUIs open showing the QoS configuration, you're ready to execute the Ansible playbooks and observe the automated changes in real-time.

Proceed to [Run Playbooks](../lab5-ansible/run-playbooks.md).



