# Script Integration & Clean-Up

## Overview

Terraform is excellent for declarative provisioning, but certain cleanup actions or tasks are:

- Procedural
- Easier to express in shell script
- Specific to lab environments
- Not easily handled by ACI provider resources

For these tasks, Terraform uses the null_resource with a local-exec provisioner.

The scripts folder provides a clean, reusable location for external helper scripts that Terraform can call during certain lifecycle events (e.g., terraform destroy). This reset_qos.sh script provides a consistent and automated way to reset QoS configuration on the APIC.

In this section, you will create helper scripts to streamline Terraform operations and clean up configurations when needed.

## Create Cleanup Script

Create a scripts folder and script file to destroy the Terraform-managed infrastructure:

```bash
cd /opt/tf/terraform
mkdir scripts
cd scripts
vi reset_qos.sh
```

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

Add the following content:

```bash
#!/bin/bash
set -e

APIC_URL="$1"
USERNAME="admin"
PASSWORD="C1sco12345"
COOKIE_FILE="/tmp/apic-cookie-$$.txt"

echo "Resetting QoS configuration on $APIC_URL..."

# Logging In to APIC: The script authenticates to the APIC using the AAA login API and stores the session token in the unique cookie file:

curl -sk -X POST "$APIC_URL/api/aaaLogin.json" \
  -H "Content-Type: application/json" \
  -d "{\"aaaUser\":{\"attributes\":{\"name\":\"$USERNAME\",\"pwd\":\"$PASSWORD\"}}}" \
  -c "$COOKIE_FILE"

# Reset QoS Class Level2 config (Tail-drop + PFC disabled)

curl -sk -X POST "$APIC_URL/api/node/mo/uni.xml" \
  -H "Content-Type: application/xml" \
  -d '<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
         <qosCong algo="tail-drop" ecn="disabled"/>
         <qosPfcPol name="default" adminSt="no" noDropCos=""/>
       </qosClass>' \
  -b "$COOKIE_FILE"


# Reset QoS Class Level2 Bandwidth allocated to 20%

curl -sk -X POST "$APIC_URL/api/node/mo/uni/infra/qosinst-default/class-level2/sched.json" \
  -H "Content-Type: application/json" \
  -d '{"qosSched":{"attributes":{"dn":"uni/infra/qosinst-default/class-level2/sched","bw":"20"},"children":[]}}' \
  -b "$COOKIE_FILE"

rm -f "$COOKIE_FILE"

echo "Reset complete."

```

## Save the File

Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

Once outside the vi editor, the file can be verified by typing:

```bash
cat reset_qos.sh
```

Make the script executable:

```bash
chmod +x reset_qos.sh
```

!!! Optional "Optional"
    You can test the script manually though it's primarily for terraform destroy

```bash
bash reset_qos.sh https://apic1-a.corp.pseudoco.com 
```

```bash
bash reset_qos.sh https://apic1-b.corp.pseudoco.com 
```

This ensures that any RoCEv2-specific configuration applied by the lab is removed cleanly.
Cleaning Up the Cookie File and Exiting: The temporary cookie file is deleted, and a completion message is printed.

## Next Steps

Proceed to [Apply Terraform](apply-terraform.md) to deploy your RoCEv2 QoS configuration to both ACI fabrics.
