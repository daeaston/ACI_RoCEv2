# Create inventory.ini File

## About Inventory Files

The Ansible inventory file defines which hosts (APIC controllers in our case) the playbooks will run against. It also allows you to define groups of hosts and set variables that apply to those groups.

## Create the Inventory File

- Create the `inventory.ini` file in `/opt/ansible` by executing `vi inventory.ini` and pasting the following content:

```bash
vi inventory.ini
```

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below in one go from the beginning to the end.

## Inventory File Content

```ini
[apic]
apic1-a.corp.pseudoco.com
apic1-b.corp.pseudoco.com

[apic:vars]
ansible_connection=local
apic_username=admin
apic_password=C1sco12345
```

!!! warning "Credentials in Inventory"
    This lab uses hardcoded credentials for simplicity. In production environments, use Ansible Vault or external secret management systems to protect sensitive credentials.

## Save the File

- Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

- Once outside the vi editor, the script can be verified by typing:

```bash
cat inventory.ini
```

## Understanding the Inventory

- **[apic]** - Defines a host group named "apic"
- **apic1-a.corp.pseudoco.com** and **apic1-b.corp.pseudoco.com** - The two APIC controllers
- **[apic:vars]** - Variables that apply to all hosts in the "apic" group
- **ansible_connection=local** - Tells Ansible to run API calls locally rather than SSH
- **apic_username** and **apic_password** - Credentials for APIC authentication

Proceed to [Group Variables File](../lab5-ansible/group-vars-file.md).




