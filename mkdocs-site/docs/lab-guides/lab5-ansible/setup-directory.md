# Setup Directory Structure

## Create Ansible Directory

- Log in to the tools machine and create the `ansible` directory under `/opt/` then move to it:

```bash
mkdir /opt/ansible
cd /opt/ansible
```

## Create Subdirectories

- Create the following subdirectories `group_vars` and `playbooks` underneath `ansible`:

```bash
mkdir group_vars
mkdir playbooks
```

## Directory Structure

Your final directory structure should look like this:

```
/opt/ansible/
├── inventory.ini
├── group_vars/
│   └── apic.yml
└── playbooks/
    ├── rocev2_qos.yml
    └── reset_qos.yml
```

This structure follows Ansible best practices:

- **inventory.ini** - Defines the APIC hosts to automate
- **group_vars/** - Contains variables shared across host groups
- **playbooks/** - Contains the automation playbooks

Proceed to [Inventory File](../lab5-ansible/inventory-file.md).

