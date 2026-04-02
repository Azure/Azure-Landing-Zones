---
title: 14 - Change Firewall SKU
geekdocCollapseSection: true
weight: 14
---

The full scenarios default to Azure Firewall Premium SKU, which supports features like HTTPS inspection for [zero trust](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust) networking. You can change the SKU to Standard or Basic if needed.

The steps to follow are:

1. Update each firewall SKU in the `custom_replacements` > `names` block setting.

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `<region>_firewall_sku_tier` | Update the value to `"Basic"`, `"Standard"`, or `"Premium"` | 1+ | `<region>` is the relevant region (e.g. primary or secondary). There will be two instances for a multi-region deployment |
