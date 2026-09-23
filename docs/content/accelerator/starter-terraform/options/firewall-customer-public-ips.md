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
This option applies to the **Virtual WAN** connectivity type only. Hub and spoke virtual network deployments already let you supply the firewall public IP directly.
{{< /hint >}}

## Prerequisites

Create the public IP addresses before you deploy. The firewall attaches addresses that you own; it does not create them or manage their lifecycle.

Each public IP address must meet the [secured hub prerequisites](https://learn.microsoft.com/azure/firewall/secured-hub-customer-public-ip):

| Requirement | Value |
| - | - |
| SKU | `Standard` |
| Allocation method | `Static` |
| Subscription | The same subscription as the firewall, which is your connectivity subscription |
| Region | The same region as the hub |
| Availability zones | Must match the firewall's zones |
| Association | Not attached to any other resource |

{{< hint type=warning >}}
**Zone mismatches are not caught until deployment.** If your firewall is zone redundant across zones 1, 2 and 3, a public IP created in only zone 1 passes validation and then fails roughly ten minutes into the deployment with `AzureFirewallZoneConstraintDoesNotMatchPublicIpAddressZoneConstraint`. Check the zones on every public IP before you deploy.
{{< /hint >}}

{{< hint type=warning >}}
**Public IPs in a different subscription are rejected**, and the error is misleading. Azure reports `InvalidResourceReference` stating the address "was not found" and suggests checking the region, even when the address exists and the regions match. If you see that error, check the subscription first.
{{< /hint >}}

## Steps

1. Update the firewall block for each hub in the `custom_replacements` > `names` block setting.

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `virtual_hubs` > `<hub>` > `firewall` | `vhub_public_ip_count` | Update the value to `"0"` | 1+ | One per hub that uses customer IPs. There will be two instances for a multi-region deployment |
    | block | `virtual_hubs` > `<hub>` > `firewall` | `ip_configurations` | Add the block, with one entry per public IP address | 1+ | One per hub that uses customer IPs |

1. Inside each `ip_configurations` block, add one entry per public IP address. Each entry needs a `name` and a `public_ip_address_id`.

The result looks like the following. Merge this `firewall` block into your existing hub definition, keeping the firewall settings you already have.

{{< highlight terraform "linenos=table" >}}
virtual_hubs = {
  primary = {
    # ... your existing hub settings ...

    firewall = {
      sku_tier             = "Premium"
      vhub_public_ip_count = "0"

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
**You cannot convert an existing firewall between managed and customer IPs by editing your configuration.** This applies in both directions, and includes removing the last entry from `ip_configurations`.

Use this option when creating a **new** firewall. To convert one that already exists, follow the manual procedure below.
{{< /hint >}}

The accelerator deliberately blocks conversion. Editing the configuration of a deployed firewall produces an error rather than a conversion, which prevents an accidental edit from taking a production firewall offline.

The underlying reason is that the two modes are different resource types in Terraform, so no configuration change can turn one into the other. Azure itself supports the conversion, but only through a separate procedure, after which the firewall must be adopted back into your deployment as a new resource.

If you must convert an existing firewall, treat it as a planned maintenance activity:

1. Confirm the public IP addresses you intend to attach meet every prerequisite above, including zones.
1. Deallocate the firewall from its hub using [`Deallocate`](https://learn.microsoft.com/azure/firewall/firewall-multi-hub-spoke), then save the firewall.
1. Clear the existing public IP record. After deallocation the firewall still holds its original address, and allocating with IP configurations fails with `AzHubFwClassicIPAddressesExistOnAllocate` until you set the public IP count to zero and the address list to empty, then save the firewall again.
1. Allocate the firewall back to the hub, supplying your own public IP addresses.
1. Adopt the converted firewall back into your deployment.

{{< hint type=warning >}}
Step 3 is required and is easy to miss. Deallocating a firewall does **not** release its existing public IP address, so the allocation in step 4 fails until the record is cleared explicitly.
{{< /hint >}}

Plan for the firewall to be unavailable for the duration. The firewall's private IP address is normally preserved across the conversion, so hub routing is unaffected, but do not rely on this without confirming it in your own environment.
