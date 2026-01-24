# Bruno Overview

![Bruno](../../assets/images/image038.png)

Bruno is a lightweight, open-source REST client designed for automation and API workflows. It stores API requests as plain text files (JSON or YAML), making them easy to version-control and share alongside Terraform, Ansible, or Python code. This makes Bruno well suited for exploring and validating APIs such as the Cisco ACI APIC in a clear and repeatable way.

In practice, Bruno is used to prototype and test API calls before automating them. Engineers can quickly verify requests and responses, switch between environments, and confirm behaviour across multiple fabrics. This makes Bruno a useful bridge between manual API exploration and fully automated IaC workflows.

## What is Bruno?

Bruno is a modern API client that:

- **Stores collections as files** - Git-friendly, text-based storage
- **Supports environments** - Easy switching between dev/test/prod
- **Provides scripting** - Pre-request and post-response scripts
- **Works offline** - No cloud dependency
- **Open Source** - Free and community-driven

## Why Use Bruno for ACI?

- **Visual Interface** - See API requests and responses clearly
- **Learning Tool** - Understand ACI REST API structure
- **Testing** - Quickly test API calls before coding
- **Documentation** - Self-documenting API collections
- **Sharing** - Export collections for team collaboration

This section covers using Bruno to interact with the APIC API for QoS configuration.

## Next Steps

Proceed to [Import Collection](import-collection.md) to deploy RoCEv2 QoS configuration using the Bruno API client.
