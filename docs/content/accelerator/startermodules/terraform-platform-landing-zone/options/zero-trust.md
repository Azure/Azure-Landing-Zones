---
title: 14 - Zero Trust Networking
geekdocCollapseSection: true
weight: 14
---

If you are looking to deploy [zero trust](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust) practices into your Landing Zone, you should enable Azure Firewall Premium SKU.
This will enable the HTTPS inspection feature, which is a key component of zero trust.

The steps to follow are:

1. Update each firewall SKU to `"Premium"` in the `hub_and_spoke_vnet_virtual_networks` block setting.

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `hub_and_spoke_vnet_virtual_networks` > `<region>` >  `hub_virtual_network` > `firewall` | `sku_tier` | Update the value from `"Standard"` to `"Premium"` | 1+ | <region> is the relevant region (e.g. primary or secondary). There will be two instances for a multi-region deployment |
