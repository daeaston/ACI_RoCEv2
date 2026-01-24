# DEVWKS - RoCEv2 QoS Automation on Cisco ACI Workshop

## Overview

This workshop guides you through implementing and automating RoCEv2 (RDMA over Converged Ethernet version 2) QoS policies on Cisco Application Centric Infrastructure (ACI) using multiple automation approaches.

### What You'll Learn

- Understanding RoCEv2 and its importance in modern data centers
- Implementing QoS policies for RoCEv2 on Cisco ACI
- Automating ACI configuration using:
  - Terraform with custom modules
  - Terraform with NAC (Network as Code)
  - Python with ACI SDK
  - Bruno API client for REST API interactions
  - Ansible playbooks for orchestration

### Workshop Structure

1. **Introduction** - Learn about RoCEv2, lab environment, and prerequisites
2. **Lab 1** - Terraform Custom Module approach
3. **Lab 2** - Terraform NAC approach
4. **Lab 3** - Python automation
5. **Lab 4** - Bruno API automation
6. **Lab 5** - Ansible Playbooks automation

## Local Development

### Prerequisites

- Python 3.8 or higher
- pip package manager

### Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/DEVWKS-ACI-RoCEv2.git
   cd DEVWKS-ACI-RoCEv2
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Serve the documentation locally:
   ```bash
   mkdocs serve
   ```

4. Open your browser to `http://localhost:8000`

## Building the Site

To build the static site:

```bash
mkdocs build
```

The built site will be in the `site/` directory.

## Deployment

This site is automatically deployed to GitHub Pages when changes are pushed to the main branch using GitHub Actions.

## Contributing

This workshop material was created for Cisco Live / DevNet events. If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## Author

David Easton

## License

Copyright © 2024-2026 Cisco Systems, Inc.

## Acknowledgments

Special thanks to the Cisco ACI and DevNet teams for their support in creating this workshop.
