# NAC Script Integration

## Overview

This script provides a simple, direct way to reset the QoS configuration on an APIC cluster using raw REST API calls via curl. It is executed from Terraform as part of the null_resource provisioners during terraform destroy. This is the same as the previous Terraform exercise.

## Create Reset Script

- Navigate back to the nac-aci-simple-example directory, create, then go into into the scripts directory:

```bash
cd ..
mkdir scripts
cd scripts
```

- Create the reset_qos.sh script:

```bash
vi reset_qos.sh
```

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

```bash
#!/bin/bash

APIC_URL="$1"
USERNAME="admin"
PASSWORD="C1sco12345"

echo "Resetting QoS configuration on $APIC_URL..."

# Sends a login request to the APIC and saves the authentication cookie to apic-cookie.txt for later API calls.

curl -sk -X POST "$APIC_URL/api/aaaLogin.json" \
  -H "Content-Type: application/json" \
  -d "{\"aaaUser\":{\"attributes\":{\"name\":\"$USERNAME\",\"pwd\":\"$PASSWORD\"}}}" \
  -c apic-cookie.txt

# Sends an XML payload to the APIC to reset the QoS class configuration back to its default settings

curl -sk -X POST "$APIC_URL/api/node/mo/uni.xml" \
  -H "Content-Type: application/xml" \
  -d '<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
         <qosCong algo="tail-drop" ecn="disabled"/>
         <qosPfcPol name="default" adminSt="no" noDropCos="" enableScope="fabric"/>
         <qosSched bw="20"/>
       </qosClass>' \
  -b apic-cookie.txt

echo "Reset complete."

```

## Save the File

- Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

- Once outside the vi editor, the file can be verified by typing:

```bash
cat reset_qos.sh
```

## Next Steps

Proceed to [Apply Terraform](apply-terraform.md) to deploy the NAC configuration to both ACI fabrics.
