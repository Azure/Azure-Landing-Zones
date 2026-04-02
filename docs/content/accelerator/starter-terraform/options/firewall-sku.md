---
title: 14 - Change Firewall SKU
geekdocCollapseSection: true
weight: 14
---

The full scenarios default to Azure Firewall Premium SKU, which supports features like HTTPS inspection for [zero trust](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust) networking. You can change the SKU to Standard or Basic if needed.

{{< hint type=warning >}}
**Downgrading from Premium to Standard** removes [TLS inspection](https://learn.microsoft.com/azure/firewall/premium-features#tls-inspection) (HTTPS inspection), [IDPS](https://learn.microsoft.com/azure/firewall/premium-features#idps) (signature-based intrusion detection and prevention), and [URL filtering](https://learn.microsoft.com/azure/firewall/premium-features#url-filtering) for full URL path matching. These are key capabilities for zero trust networking.
{{< /hint >}}

{{< hint type=warning >}}
**Downgrading from Standard to Basic** additionally removes DNS proxy support. Without DNS proxy, Azure Firewall cannot act as the DNS intermediary for spoke virtual networks, which means centralized Private DNS zone resolution via Azure Firewall will not work. If you use the Basic SKU, Private DNS zones should be managed directly in spoke subscriptions instead.
{{< /hint >}}

The steps to follow are:

1. Update each firewall SKU in the `custom_replacements` > `names` block setting.

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `<region>_firewall_sku_tier` | Update the value to `"Basic"`, `"Standard"`, or `"Premium"` | 1+ | `<region>` is the relevant region (e.g. primary or secondary). There will be two instances for a multi-region deployment |
