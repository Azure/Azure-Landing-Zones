---
title: 5 - Turn off Private DNS zones and Private DNS resolver
geekdocCollapseSection: true
weight: 5
---

You can choose to not deploy any DNS related resources. In order to do that, they need to remove the DNS configuration and disable the DINE (deploy if not exists) policy. You can either comment out or remove the configuration entirely.

The steps to follow are:

1. To keep the code tidy remove the follow settings from `custom_replacements.names`:
    * `dns_resource_group_name`
    * `<region>_private_dns_resolver_name` where `<region>` is for each region
    * `<region>_auto_registration_zone_name` where `<region>` is for each region
    * `<region>_private_dns_resolver_subnet_address_prefix` where `<region>` is for each region
1. Remove the follow configuration settings from `management_group_settings.policy_default_values`:
    * `private_dns_zone_subscription_id`
    * `private_dns_zone_region`
    * `private_dns_zone_resource_group_name`
1. Add the follow section to `management_group_settings.policy_assignments_to_modify`:

    ```terraform
    corp = {
      policy_assignments = {
        Deploy-Private-DNS-Zones = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    ```

1. Remove the whole `private_dns_zones` section from each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region
