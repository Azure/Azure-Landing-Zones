---
title: Azure Policy
geekdocCollapseSection: true
weight: 30
---

This section documents all the Azure Landing Zones specific Azure Policy details.

{{< hint type=note >}}
This section is a work in progress as we slowly move content from the [wiki](https://aka.ms/alz/policy).
{{< /hint >}}

## Table of Contents

- [Policy Versioning]({{< relref "policyVersioning" >}})
- [Policy Assignments by Archetype](#azure-landing-zones-policy-assignments-by-archetype)
  - [Overview](#overview)
    - [Key Concepts](#key-concepts)
    - [Policy Inheritance Model](#policy-inheritance-model)
  - [Archetype Policy Assignments](#archetype-policy-assignments)
    - [Root Archetype](#root-archetype)
    - [Platform Archetype](#platform-archetype)
    - [Landing Zones Archetype](#landing-zones-archetype)
    - [Corp Archetype](#corp-archetype)
    - [Connectivity Archetype](#connectivity-archetype)
    - [Identity Archetype](#identity-archetype)
    - [Sandbox Archetype](#sandbox-archetype)
    - [Decommissioned Archetype](#decommissioned-archetype)
  - [Additional Assets](#additional-assets)
  - [References](#references)

# Azure Landing Zones Policy Assignments by Archetype

This document provides a comprehensive overview of the policy assignments applied through archetypes in Azure Landing Zones using the Azure Landing Zones Library approach.

## Overview

Azure Landing Zones uses an **archetype-based** approach to apply policies to management groups. An archetype is a collection of policy assignments, policy definitions, policy set definitions, and role definitions that can be applied to one or more management groups.

### Key Concepts

- **Archetypes**: Reusable collections of governance assets (policies, roles, etc.)
- **Inheritance**: Policies assigned to parent management groups are inherited by child management groups
- **Extensibility**: Multiple archetypes can be applied to the same management group
- **Customization**: Archetype overrides allow modification without changing base definitions

### Policy Inheritance Model

```
Root Management Group (15 policies from "root" archetype)
├── Platform Management Group (+12 policies from "platform" archetype = 27 total)
│   ├── Connectivity (+1 policy from "connectivity" archetype = 28 total)
│   ├── Identity (+4 policies from "identity" archetype = 31 total)
│   └── Management (27 total)
├── Landing Zones Management Group (+25 policies from "landing_zones" archetype = 40 total)
│   ├── Corp (+5 policies from "corp" archetype = 45 total)
│   └── Online (40 total)
├── Sandbox Management Group (+1 policy from "sandbox" archetype = 16 total)
└── Decommissioned Management Group (+1 policy from "decommissioned" archetype = 16 total)
```

## Archetype Policy Assignments

### Root Archetype
**Applied to**: Root/Intermediate Root Management Group  
**Inherited by**: All management groups  
**Focus**: Foundation security, governance, and monitoring

| Policy Assignment | Category | Purpose |
|-------------------|----------|---------|
| `Audit-ResourceRGLocation` | Governance | Ensure resources are deployed in approved regions |
| `Audit-TrustedLaunch` | Security | Audit VMs without Trusted Launch enabled |
| `Audit-UnusedResources` | Cost Optimization | Identify unused resources for cost savings |
| `Audit-ZoneResiliency` | Resilience | Audit resources without availability zone configuration |
| `Deny-Classic-Resources` | Modernization | Prevent deployment of classic Azure resources |
| `Deny-UnmanagedDisk` | Security | Prevent use of unmanaged disks |
| `Deploy-ASC-Monitoring` | Security | Deploy Azure Security Center monitoring |
| `Deploy-AzActivity-Log` | Monitoring | Configure Azure Activity Log diagnostics |
| `Deploy-Diag-LogsCat` | Monitoring | Deploy diagnostic settings for all log categories |
| `Deploy-MDEndpoints` | Security | Deploy Microsoft Defender for Endpoint |
| `Deploy-MDEndpointsAMA` | Security | Deploy Microsoft Defender for Endpoint with AMA |
| `Deploy-MDFC-Config-H224` | Security | Configure Microsoft Defender for Cloud |
| `Deploy-MDFC-OssDb` | Security | Configure Defender for open-source databases |
| `Deploy-MDFC-SqlAtp` | Security | Configure Defender for SQL Advanced Threat Protection |
| `Enforce-ACSB` | Compliance | Enforce Azure Compute Security Benchmark |

**Total Policies**: 15

### Platform Archetype
**Applied to**: Platform Management Group  
**Inherited by**: Connectivity, Identity, Management management groups  
**Focus**: Shared platform services monitoring, security, and governance

| Policy Assignment | Category | Purpose |
|-------------------|----------|---------|
| `DenyAction-DeleteUAMIAMA` | Security | Prevent deletion of User Assigned Managed Identity for AMA |
| `Deploy-MDFC-DefSQL-AMA` | Security | Deploy Defender for SQL with Azure Monitor Agent |
| `Deploy-VM-ChangeTrack` | Monitoring | Enable change tracking for virtual machines |
| `Deploy-VM-Monitoring` | Monitoring | Deploy VM monitoring with Azure Monitor |
| `Deploy-vmArc-ChangeTrack` | Monitoring | Enable change tracking for Arc-enabled VMs |
| `Deploy-vmHybr-Monitoring` | Monitoring | Deploy monitoring for hybrid VMs |
| `Deploy-VMSS-ChangeTrack` | Monitoring | Enable change tracking for VM Scale Sets |
| `Deploy-VMSS-Monitoring` | Monitoring | Deploy VMSS monitoring with Azure Monitor |
| `Enable-AUM-CheckUpdates` | Patch Management | Enable automatic update management checks |
| `Enforce-ASR` | Data Protection | Enforce Azure Site Recovery policies |
| `Enforce-GR-KeyVault` | Security | Enforce guardrails for Key Vault |
| `Enforce-Subnet-Private` | Security | Ensure subnets are private by default |

**Total Policies**: 12 (+ 15 inherited from root = 27 total)

### Landing Zones Archetype
**Applied to**: Landing Zones Management Group  
**Inherited by**: Corp, Online management groups  
**Focus**: Workload security, compliance, and governance

| Policy Assignment | Category | Purpose |
|-------------------|----------|---------|
| `Audit-AppGW-WAF` | Security | Ensure Application Gateway has WAF enabled |
| `Deny-IP-forwarding` | Network Security | Prevent IP forwarding on network interfaces |
| `Deny-MgmtPorts-Internet` | Security | Block management ports from internet access |
| `Deny-Priv-Esc-AKS` | Security | Prevent privilege escalation in AKS clusters |
| `Deny-Privileged-AKS` | Security | Deny privileged containers in AKS |
| `Deny-Storage-http` | Security | Enforce HTTPS for storage accounts |
| `Deny-Subnet-Without-Nsg` | Network Security | Require NSGs on all subnets |
| `Deploy-AzSqlDb-Auditing` | Compliance | Enable SQL database auditing |
| `Deploy-MDFC-DefSQL-AMA` | Security | Deploy Defender for SQL with AMA |
| `Deploy-SQL-TDE` | Security | Enable Transparent Data Encryption for SQL |
| `Deploy-SQL-Threat` | Security | Enable SQL threat detection |
| `Deploy-VM-Backup` | Data Protection | Configure VM backup policies |
| `Deploy-VM-ChangeTrack` | Monitoring | Enable change tracking for VMs |
| `Deploy-VM-Monitoring` | Monitoring | Deploy VM monitoring with Azure Monitor |
| `Deploy-vmArc-ChangeTrack` | Monitoring | Enable change tracking for Arc VMs |
| `Deploy-vmHybr-Monitoring` | Monitoring | Deploy monitoring for hybrid VMs |
| `Deploy-VMSS-ChangeTrack` | Monitoring | Enable change tracking for VMSS |
| `Deploy-VMSS-Monitoring` | Monitoring | Deploy VMSS monitoring |
| `Enable-AUM-CheckUpdates` | Patch Management | Enable automatic update checks |
| `Enable-DDoS-VNET` | Security | Enable DDoS protection on VNets |
| `Enforce-AKS-HTTPS` | Security | Enforce HTTPS for AKS clusters |
| `Enforce-ASR` | Data Protection | Enforce Azure Site Recovery policies |
| `Enforce-GR-KeyVault` | Security | Enforce Key Vault guardrails |
| `Enforce-Subnet-Private` | Security | Ensure subnets are private by default |
| `Enforce-TLS-SSL-Q225` | Security | Enforce TLS/SSL requirements |

**Total Policies**: 25 (+ 15 inherited from root = 40 total)

### Corp Archetype
**Applied to**: Corp Management Group (under Landing Zones)  
**Focus**: Corporate connectivity and private endpoint configuration

| Policy Assignment | Category | Purpose |
|-------------------|----------|---------|
| `Audit-PeDnsZones` | Network | Audit private endpoint DNS zones |
| `Deny-HybridNetworking` | Network Security | Prevent unauthorized hybrid connectivity |
| `Deny-Public-Endpoints` | Security | Block public endpoints for PaaS services |
| `Deny-Public-IP-On-NIC` | Network Security | Prevent public IPs on network interfaces |
| `Deploy-Private-DNS-Zones` | Network | Deploy private DNS zones for private endpoints |

**Total Policies**: 5 (+ 40 inherited from root + landing_zones = 45 total)

### Connectivity Archetype
**Applied to**: Connectivity Management Group (under Platform)  
**Focus**: Network protection

| Policy Assignment | Category | Purpose |
|-------------------|----------|---------|
| `Enable-DDoS-VNET` | Security | Enable DDoS protection on virtual networks |

**Total Policies**: 1 (+ 27 inherited from root + platform = 28 total)

### Identity Archetype
**Applied to**: Identity Management Group (under Platform)  
**Focus**: Hardening identity infrastructure

| Policy Assignment | Category | Purpose |
|-------------------|----------|---------|
| `Deny-MgmtPorts-Internet` | Security | Block management ports from internet |
| `Deny-Public-IP` | Network Security | Prevent public IP creation |
| `Deny-Subnet-Without-Nsg` | Network Security | Require NSGs on all subnets |
| `Deploy-VM-Backup` | Data Protection | Configure backup for identity VMs |

**Total Policies**: 4 (+ 27 inherited from root + platform = 31 total)

### Sandbox Archetype
**Applied to**: Sandbox Management Group  
**Focus**: Limited governance for testing environments

| Policy Assignment | Category | Purpose |
|-------------------|----------|---------|
| `Enforce-ALZ-Sandbox` | Governance | Apply sandbox-specific guardrails |

**Total Policies**: 1 (+ 15 inherited from root = 16 total)

### Decommissioned Archetype
**Applied to**: Decommissioned Management Group  
**Focus**: Prevent activities in decommissioned subscriptions

| Policy Assignment | Category | Purpose |
|-------------------|----------|---------|
| `Enforce-ALZ-Decomm` | Governance | Enforce decommissioning guardrails |

**Total Policies**: 1 (+ 15 inherited from root = 16 total)


## Additional Assets

The **root** archetype also includes:
- **114 Custom Policy Definitions**: Including policies like `Deny-PublicIP`, `Deploy-MDFC-Config`, etc.
- **45 Policy Set Definitions**: Initiatives that group related policies together
- **5 Role Definitions**: Custom RBAC roles for platform operations


## References

- [Azure Landing Zones Library](https://github.com/Azure/Azure-Landing-Zones-Library)
- [Azure Landing Zones Library Documentation](https://azure.github.io/Azure-Landing-Zones-Library/)
- [Archetype Definitions](https://azure.github.io/Azure-Landing-Zones-Library/assets/archetypes/)
- [Policy Assignments](https://azure.github.io/Azure-Landing-Zones-Library/assets/policy-assignments/)
- [AZ Policy Advertiser]([https://azure.github.io/Azure-Landing-Zones-Library/assets/policy-assignments/](https://www.azadvertizer.net/azpolicyadvertizer_all.html))



This documentation is based on the Azure Landing Zones Library archetype definitions as of the current main branch. Policy assignments may be updated over time to reflect the latest security and governance best practices.

For the most current policy assignments, refer to the archetype definition files in the [Azure Landing Zones Library repository](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz).
