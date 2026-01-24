# NAC Environment Setup

Cisco Netascode provides a higher-level, intent-driven approach to network automation. Instead of managing low-level Terraform resources and dependencies, engineers define the desired network state using structured inputs such as YAML, while Cisco-curated modules handle the underlying configuration.

![NAC](../../assets/images/image037.png)

This approach reduces complexity for platforms such as ACI, SD-WAN, ISE, and Meraki by embedding validation and best practices directly into the workflow. The result is faster, more consistent deployments with a lower risk of configuration errors.

Traditional Terraform offers greater flexibility and multi-vendor reach but requires more manual effort and expertise. Netascode trades some low-level control for speed, consistency, and reliability, making it well suited to standardised, Cisco-centric environments at scale.

- [Cisco Netascode Site](https://netascode.cisco.com/)
- [Netascode ACI Section](https://netascode.cisco.com/docs/start/aci/introduction/)
- [Netascode Data Models Programmability](https://netascode.cisco.com/docs/data_models/)
- [Netascode ACI QoS](https://netascode.cisco.com/docs/data_models/apic/access_policies/qos/)

This section demonstrates using the Netascode Terraform module to deploy an equivalent RoCEv2 QoS configuration using a declarative, YAML-driven approach. The module maps the YAML intent to the correct ACI attributes, removing the need to manage XML payloads or REST API calls directly.

In this model, the YAML file defines what the RoCEv2 QoS policy should look like, while Netascode and Terraform act as the engine that translates that intent into actual APIC configuration:

!!! warning "Please ensure Terraform is already installed from Lab 1"
    If you have gone straight to this Lab without having completed Lab 1, please go straight to the 'Install Terraform' section.

## Next Steps

Proceed to [NAC Setup](../lab2-terraform-nac/nac-setup.md) to learn about Network as Code with YAML-driven configuration.
