# Executing the Python Script

## Overview

In this final section, you will create and execute a Python script that deploys RoCEv2 QoS policies to both ACI fabrics using the REST API.

# Login to Both APICs

Login to each APIC in the same way as has been previously done via the Terraform exercises to validate this script working in the exact same way, with each screen showing the Level 2 QoS configuration:

![apic](../../assets/images/image013.png)

## Executing the Python Script

- Open Command Prompt again from the Taskbar, change the directory to the Python Folder

- Run the Python script to apply the configuration: **python rocev2_qos.py apply**

```bash
python rocev2_qos.py apply
```

![python apply](../../assets/images/image023.png)

- Observe the changes in the APIC GUI.
- Run the Python script to reset the configuration: **python rocev2_qos.py destroy**

```bash
python rocev2_qos.py destroy
```

- Observe the APIC GUI reverting to its normal state.

## Lab 3 Complete!

Congratulations! You have successfully:

- ✅ Installed Python and ACI SDK
- ✅ Created authentication module
- ✅ Deployed RoCEv2 QoS via Python
- ✅ Verified configuration in APIC GUI

### Key Takeaways

1. **Python provides maximum flexibility** - Full programming capabilities
2. **REST API direct access** - Understand exactly what's happening
3. **Requires more code** - But offers more control
4. **Great for integration** - Easy to connect with other systems

## Next Steps

Ready for the next approach? Proceed to [Lab 4: Bruno API](../lab4-bruno/bruno-overview.md) to explore API automation using the Bruno GUI client.
