---
title: Migration Guidance
description: Migration guidance from CAF Enterprise Scale to Azure Verified Modules for Platform Landing Zones (ALZ)
geekdocCollapseSection: true
weight: 200
---

This section provides step by step guidance for migrating from the [CAF Enterprise Scale](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale) module to the new [Azure Verified Modules for Platform Landing Zones (ALZ)]({{< relref "/accelerator/startermodules/terraform-platform-landing-zone" >}}).

## Introduction

There are two main parts to the migration process:

1. **Connectivity and Management Resources**: We provide guidance and tooling to migrate the state of the connectivity and management resources to the ALZ modules.
1. **Management Groups and Policy**: We provide guidance and tooling to migrate the state of the management group hierarchy and policy assignments to the ALZ modules.

## Migration Process

First of all you need to determine what you already have deployed in your environment. There are 4 components to consider:

- Management resources (migration path 1)
- Connectivity resources with Virtual WAN (migration path 1)
- Connectivity resources with Hub and Spoke Virtual Networks (migration path 1)
- Management groups and policy (migration path 2)

Take a look at your CAF Enterprise Scale deployment and determine which of the above components you have deployed. You can then follow the appropriate migration guide(s) below. If you have both, then start with management and connectivity first and then move onto management groups and policy.

1. [Management and Connectivity Resources]({{< relref "resources" >}})
1. [Management Groups and Policy]({{< relref "managementgroups" >}})
