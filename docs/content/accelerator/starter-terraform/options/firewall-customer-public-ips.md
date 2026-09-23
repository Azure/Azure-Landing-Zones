---
title: 17 - Use customer provided public IPs for Azure Firewall
geekdocCollapseSection: true
weight: 17
---

By default, a secured Virtual WAN hub lets Azure allocate the public IP addresses for Azure Firewall. You control how many you get, but not which addresses they are.

You may need to choose the addresses yourself, for example to:

- Share a fixed set of egress addresses with a partner or regulator who allow-lists them
- Draw the addresses from a public IP prefix that your organization already owns
- Keep the address lifecycle separate from the firewall lifecycle, so rebuilding the firewall does not change your egress IPs

This option replaces the managed public IP count with a map of public IP addresses that you create and own.

{{< hint type=note >}}
This option applies to the **Virtual WAN** connectivity type only.
{{< /hint >}}

## Prerequisites

Create the public IP addresses before you deploy. The firewall attaches addresses that you own; it does not create them or manage their lifecycle.

The firewall must use the `Standard` or `Premium` SKU tier. The `Basic` tier is not supported with customer provided public IP addresses.

Each public IP address must meet the [secured hub prerequisites](https://learn.microsoft.com/azure/firewall/secured-hub-customer-public-ip):

| Requirement | Value |
| - | - |
| SKU | `Standard` |
| Tier | `Regional` |
| IP version | `IPv4` |
| Allocation method | `Static` |
| Subscription | The same subscription as the firewall, which is your connectivity subscription |
| Region | The same region as the hub |
| Availability zones | Must match the firewall's zones |
| Association | Not attached to any other resource |

{{< hint type=warning >}}
**Zone mismatches are not caught until deployment.** If your firewall is zone redundant across zones 1, 2 and 3, a public IP created in only zone 1 passes validation and then fails roughly ten minutes into the deployment with `AzureFirewallZoneConstraintDoesNotMatchPublicIpAddressZoneConstraint`. Check the zones on every public IP before you deploy.
{{< /hint >}}

{{< hint type=note >}}
**Public IPs in a different subscription are rejected when you plan the deployment**, before any change is made in Azure, with the error `Every customer public IP must be in the firewall's subscription.` Create the public IP addresses in your connectivity subscription.
{{< /hint >}}

## Steps

1. Add an `ip_configurations` block to the `firewall` block of each hub in the `virtual_hubs` setting.

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | block | `virtual_hubs` > `<hub>` > `firewall` | `ip_configurations` | Add the block, with one entry per public IP address | 1+ | One per hub that uses customer IPs. There will be two instances for a multi-region deployment |

1. Inside each `ip_configurations` block, add one entry per public IP address. Each entry needs a `name` and a `public_ip_address_id`.

The result looks like the following. Merge the `ip_configurations` block into your existing hub definition, keeping the firewall settings you already have.

{{< highlight terraform "linenos=table" >}}
virtual_hubs = {
  primary = {
    # ... your existing hub settings ...

    firewall = {
      name     = "$${primary_firewall_name}"
      sku_tier = "$${primary_firewall_sku_tier}"

      ip_configurations = {
        primary = {
          name                 = "fw-ip-primary"
          public_ip_address_id = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/rg-public-ips/providers/Microsoft.Network/publicIPAddresses/pip-fw-primary"
        }
        secondary = {
          name                 = "fw-ip-secondary"
          public_ip_address_id = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/rg-public-ips/providers/Microsoft.Network/publicIPAddresses/pip-fw-secondary"
        }
      }
    }
  }
}
{{< / highlight >}}

The map keys, `primary` and `secondary` above, are your own labels. Choose stable keys and do not rename them later, because renaming a key is treated as removing one IP configuration and adding another.

The example configurations do not set `vhub_public_ip_count`, and a firewall with customer IPs does not need it. If your configuration sets it, remove it or set it to `"0"`.

## Managed and customer modes

A firewall uses either Azure managed public IPs or your own. The two cannot be combined on the same firewall.

| `ip_configurations` | `vhub_public_ip_count` | Result |
| - | - | - |
| Omitted or empty | Omitted or `null` | Azure managed IPs, using the default count. This is the existing behaviour and is unchanged |
| Omitted or empty | A number as a string, such as `"2"` | Azure managed IPs, using that count |
| One or more entries | `"0"`, `null`, or omitted | Your own IPs. No managed addresses are allocated |
| One or more entries | A number as a string, such as `"2"` | **Not valid.** The deployment is rejected because ownership would be mixed |
| Omitted or empty | `"0"` | **Not valid.** A firewall must have at least one public IP |

{{< hint type=tip >}}
`vhub_public_ip_count` is a string, not a number. Write `"0"`, not `0`.
{{< /hint >}}

## Adding and removing addresses later

Once a firewall is using your own IPs, you can add, remove and replace addresses by editing the `ip_configurations` map. These changes update the firewall in place and do not recreate it.

{{< hint type=note >}}
Adding or removing an address is still a change to a live firewall. Apply it during a maintenance window and confirm that the deployment plan shows the firewall being **updated**, not replaced.
{{< /hint >}}

Do not remove the last entry from the map. That is a mode change, not an IP removal, and is covered in the next section.

## Converting an existing firewall

{{< hint type=important >}}
**Converting an existing firewall between managed and customer IPs is not supported.** This applies in both directions, and includes removing the last entry from `ip_configurations`.

Use this option when creating a **new** firewall.
{{< /hint >}}

The accelerator deliberately blocks conversion. Editing the configuration of a deployed firewall produces an error rather than a conversion, which prevents an accidental edit from taking a production firewall offline.

The underlying reason is that the two modes are different resource types in Terraform, so no configuration change can turn one into the other. Azure has its own procedure for [reconfiguring an existing secured hub firewall](https://learn.microsoft.com/azure/firewall/secured-hub-customer-public-ip) with customer provided public IP addresses, but the accelerator cannot take over a firewall that was converted that way. Do not use that procedure on a firewall that the accelerator manages.
