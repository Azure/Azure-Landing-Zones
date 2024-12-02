---
title: Terraform Azure Verified Modules for ALZ Platform Landing Zone
---

The `platform_landing_zone` starter module deploys the end to end platform landing zone using Azure Verified Modules. It is fully configurable to meet different customer scenarios.

This documentation covers the top scenarios and documents all available configuration settings for this module.

We aim to cover the 90% of customer scenarios. If the particular customer scenario is not covered here, it may be possible to adjust the configuration settings to match the customer requirements. If not, then it my be the case the customer needs to adjust their code post deployment.

## Configuration settings

Outside of the input config file covered elsewhere in this documentation, this starter module also accepts two additional methods of customisation:

- Platform landing zone configuration file. This is a tfvars file in HCL format that determines which resources are deployed and what type of hub networking connectivity is deployed.
- Platform landing zone library (lib) folder. This is a folder of configuration files used to customise the management groups and associated policies.

Each scenario comes with a version of the platform landing zone configuration file pre-configured for that scenario.

## Scenarios

Scenarios are common customer use cases when deploying the platform landing zone. The followin section provide a description of the scenario and link to the pre-configured files for that scenario.

### Multi-region hub and spoke vnet with Azure Firewall

### Multi-region virtual wan with Azure Firewall

### Multi-region hub and spoke vnet with NVA

### Multi-region virtual wan with NVA

### Single-region hub and spoke vnet with Azure Firewall

### Single-region virtual wan with Azure Firewall

### Management groups, policy and resources only

## How to

The how to section details how to make common configuration changes that apply to the common scenarios

### Turn off DDOS protection plan

### Turn off Bastion host

### Turn off Private DNS zones and Private DNS resolver

### Additional Regions

### IP Address Ranges


## Platform landing zone configuration file

This section details the available configuration settings for this file.

