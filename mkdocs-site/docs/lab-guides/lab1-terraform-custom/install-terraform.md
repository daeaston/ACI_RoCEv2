# Install Terraform on Tools Machine

## Overview

In this section, you will install Terraform on the CentOS 7 Tools VM. Terraform will be used to automate the deployment of RoCEv2 QoS policies on both ACI fabrics.

## Prerequisites

- Access to the Tools VM as root
- Internet connectivity (for downloading Terraform)

## Step 1: Download Terraform

- First, navigate to the working directory and download the Terraform binary:

```bash
wget https://releases.hashicorp.com/terraform/1.14.0/terraform_1.14.0_linux_amd64.zip
```

## Step 2: Extract and Install Terraform

- Extract the Terraform binary and move it to `/usr/local/bin`:

```bash
unzip terraform_1.14.0_linux_amd64.zip
mv terraform /usr/local/bin/
```

## Step 3: Verify Installation

- Verify that Terraform is installed correctly:

```bash
terraform --version
```

Expected output:

```
Terraform v1.14.0
on linux_amd64
```

!!! success "Installation Complete"
    Terraform is now installed and ready to use! A more verbose output of this can be seen in [**Appendix A**](/appendicies.md). If you are advised the version is out of date you can simply ignore 🙂.

## Next Steps

Now that Terraform is installed, proceed to [Terraform Concepts](terraform-concepts.md) to understand root and child modules before building your configuration.
