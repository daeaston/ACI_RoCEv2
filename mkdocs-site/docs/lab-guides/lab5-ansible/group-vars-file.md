# Create group_vars/apic.yml File

## About Group Variables

The `group_vars` directory contains variable files that are automatically loaded for specific host groups. By creating `apic.yml`, these variables will be available to all hosts in the `[apic]` group.

## Navigate to group_vars

- Navigate to the group_vars directory:

```bash
cd group_vars/
```

## Create the apic.yml File

- Create the `apic.yml` file by executing `vi apic.yml` and pasting the following content:

```bash
vi apic.yml
```

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

## Group Variables Content

```yaml
apic_username: admin
apic_password: C1sco12345
apic_url: "https://{{ inventory_hostname }}"
```

## Save the File

- Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

- Once outside the vi editor, the file can be verified by typing:

```bash
cat apic.yml
```

## Understanding the Variables

- **apic_username** - Username for APIC authentication
- **apic_password** - Password for APIC authentication  
- **apic_url** - Dynamically constructed URL using the inventory hostname

!!! info "Jinja2 Templating"
    The `{{ inventory_hostname }}` syntax is Jinja2 templating. Ansible will automatically replace this with the actual hostname from the inventory file for each host the playbook runs against.

This approach allows us to use a single variable definition that works for multiple APIC controllers without hardcoding specific URLs.

Proceed to [Apply QoS Playbook](../lab5-ansible/apply-qos-playbook.md).


