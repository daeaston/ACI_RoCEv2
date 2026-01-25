# Terraform Concepts - Root vs. Child Modules

## Overview

Understanding Terraform module architecture is essential for building maintainable, reusable infrastructure code. This section explains the key concepts before you build your own modules.

## Root Module

The **root module** is the main Terraform configuration directory where you run `terraform` commands. It typically contains:

- `main.tf` - Primary resource definitions and module calls
- `variables.tf` - Input variable declarations
- `terraform.tfstate` - Infrastructure state snapshot
- `terraform.tfstate.backup` - Previous state file backup

### Purpose

The root module orchestrates the overall deployment by:

- Calling child modules with specific parameters
- Managing provider configurations
- Defining top-level resources
- Setting input variables for the entire infrastructure

## Child Modules

**Child modules** are reusable components that encapsulate related resources. They are called from the root module and can be reused across different projects.

### Benefits of Child Modules

- **Reusability** - Write once, use many times
- **Abstraction** - Hide complex configurations behind simple interfaces
- **Maintainability** - Update logic in one place
- **Consistency** - Ensure standardized configurations across deployments

## Root vs Child Module Comparison

| Feature | Root Module | Child Module | 
|---------|-------------|--------------|
| **Purpose** | Entry point for Terraform	| Reusable configuration logic |
| **Location** | Top-level project directory | Subdirectory or separate module repo |
| **Terraform Commands** | init, plan, apply run here	| Not run directly |
| **RoutResponsibility** | Orchestrates the deployment | Defines how resources are built | 
| **Reusability** | Single per project | Reused multiple times with inputs | 
| **Typical Usage** | Passes variables and providers | Creates and manages resources |

---

## Module Structure

A typical child module contains:

```
modules/
└── rocev2_qos/
    ├── main.tf          # Resource definitions
    ├── variables.tf     # Input variables
```

## Our Lab Architecture

In this lab, you will build:

1. **Root Module** - Orchestrates deployment to both APIC clusters
2. **rocev2_qos Child Module** - Implements the RoCEv2 QoS configuration

This structure allows you to:

- Deploy the same QoS policy to multiple fabrics
- Maintain a single source of truth for the configuration
- Easily modify the policy across all deployments

!!! tip "Module Best Practices"
    - Keep modules focused on a single responsibility
    - Use meaningful variable names
    - Document your modules thoroughly
    - Version your modules for production use

## Next Steps

Now that you understand module architecture, proceed to [Building the Root Module](root-module.md) to create your configuration.
