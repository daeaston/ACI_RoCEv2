# NAC YAML File - qos_rocev2.nac.yaml

## Overview

The NAC YAML file defines your network configuration in a declarative, human-readable format. This file describes the RoCEv2 QoS policies without requiring Terraform/HCL knowledge.

## Create the YAML Configuration

- Navigate into the data directory and create the ‘qos_rocev2.nac.yaml’ file

```bash
cd data
vi qos_rocev2.nac.yaml
```

!!! tip "Vi Editor Tips"
    Press **i** to insert text, then copy and paste all the content below.

- Add the following content:

```yaml
---
apic:
  access_policies:
    qos:
      qos_classes:
        - level: 2
          congestion_algorithm: wred
          wred_min_threshold: 40
          wred_max_threshold: 60
          wred_probability: 10
          ecn: true
          forward_non_ecn: true
          bandwidth_percent: 60
          pfc_state: true
          no_drop_cos: cos3
          pfc_scope: fabric
```

## Save the File

- Save the file by pressing **Esc**, then typing **:wq!**

## Verify the File

- Once outside the vi editor, the file can be verified by typing:

```bash
cat qos_rocev2.nac.yaml
```

## Next Steps

Proceed to [Understanding YAML](understanding-yaml.md) for a detailed explanation of each configuration section.
