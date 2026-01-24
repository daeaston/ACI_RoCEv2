# NAC Environment Setup

## Overview

Lab 2 demonstrates the **Network as Code (NAC)** approach using the Cisco Netascode Terraform provider. Unlike Lab 1's custom modules, NAC uses YAML configuration files to define infrastructure, making it more accessible to network engineers.

## What is Network as Code (NAC)?

Network as Code is an approach that:

- Uses **YAML** instead of HCL for configuration
- Provides **higher-level abstractions** for network concepts
- Enables **non-programmers** to define infrastructure
- Maintains **Terraform's state management** benefits

## NAC vs. Custom Modules

| Aspect | Custom Modules (Lab 1) | NAC (Lab 2) |
|--------|----------------------|-------------|
| **Configuration Language** | HCL (HashiCorp Configuration Language) | YAML |
| **Skill Requirement** | Terraform expertise required | Network knowledge sufficient |
| **Abstraction Level** | Low-level resource definitions | High-level network constructs |
| **Learning Curve** | Steeper | Gentler |
| **Speed** | Faster | Slower |
| **Flexibility** | Highly flexible | Opinionated patterns |
| **Best For** | Complex custom logic | Standard network patterns |

## Lab 2 Objectives

In this lab, you will:

1. Set up the NAC Terraform environment
2. Create YAML configuration for RoCEv2 QoS
3. Deploy using the NAC provider
4. Compare with Lab 1's approach

## Steps

Navigate back to /opt/, then create a nac directory. This is where we will utilize a NAC Comparison.

```bash
cd /opt/
mkdir nac
cd nac
```

Clone the Netascode ACI simple example repository:

```bash
git clone https://github.com/netascode/nac-aci-simple-example.git
```

(Output will show cloning progress.)

Navigate into the cloned directory:

```bash
cd nac-aci-simple-example/
```

## Next Steps

Proceed to [Root main.tf](root-main-tf.md) to understand the NAC root module structure.
