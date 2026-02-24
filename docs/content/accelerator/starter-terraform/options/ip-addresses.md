---
title: 8 - IP Address Ranges
geekdocCollapseSection: true
weight: 8
---

The example configuration files that include connectivity include an out of the box set of ip address ranges. These ranges have been chosen to support a real world scenario with optimal use to avoid ip exhaustion as you scale. However you may not want to use these ranges if they may overlap with their existing ranges or they are planning to scale beyond the /16 per region we cater for.

In order to update the IP ranges, you can update the `custom_replacements` > `names` block setting that includes the IP ranges. For example if you prefer to use `172.16` or `192.168`, they could update the ranges as follows:

{{< highlight terraform "linenos=table" >}}
#####################################
### Hub and Spoke Virtual Network ###
#####################################

# Example of 172.16 IP ranges for a hub and spoke Virtual Network
# NOTE: The 172.16 prefix is only suitable for medium sized deployments as it only supports 1,000,000 ip addresses
custom_replacements = {
  names = {
    # IP Ranges Primary
    # Regional Address Space: 172.16.0.0/16
    primary_hub_address_space                          = "172.16.0.0/16"
    primary_hub_virtual_network_address_space          = "172.16.0.0/22"
    primary_firewall_subnet_address_prefix             = "172.16.0.0/26"
    primary_firewall_management_subnet_address_prefix  = "172.16.0.192/26"
    primary_bastion_subnet_address_prefix              = "172.16.0.64/26"
    primary_gateway_subnet_address_prefix              = "172.16.0.128/27"
    primary_private_dns_resolver_subnet_address_prefix = "172.16.0.160/28"

    # IP Ranges Secondary
    # Regional Address Space: 172.17.0.0/16
    secondary_hub_address_space                          = "172.17.0.0/16"
    secondary_hub_virtual_network_address_space          = "172.17.0.0/22"
    secondary_firewall_subnet_address_prefix             = "172.17.0.0/26"
    secondary_firewall_management_subnet_address_prefix  = "172.17.0.192/26"
    secondary_bastion_subnet_address_prefix              = "172.17.0.64/26"
    secondary_gateway_subnet_address_prefix              = "172.17.0.128/27"
    secondary_private_dns_resolver_subnet_address_prefix = "172.17.0.160/28"
  }
}

# Example of 192.168 IP ranges for a hub and spoke Virtual Network
# NOTE that the 192.168 prefix is only suitable for a small, single region deployment as it only supports 65,000 ip addresses
custom_replacements = {
  names = {
    # IP Ranges Primary
    # Regional Address Space: 192.168.0.0/16
    primary_hub_address_space                          = "192.168.0.0/16"
    primary_hub_virtual_network_address_space          = "192.168.0.0/22"
    primary_firewall_subnet_address_prefix             = "192.168.0.0/26"
    primary_firewall_management_subnet_address_prefix  = "192.168.0.192/26"
    primary_bastion_subnet_address_prefix              = "192.168.0.64/26"
    primary_gateway_subnet_address_prefix              = "192.168.0.128/27"
    primary_private_dns_resolver_subnet_address_prefix = "192.168.0.160/28"
  }
}

###################
### Virtual WAN ###
###################

# Example of 172.16 IP ranges for a Virtual WAN
# NOTE: The 172.16 prefix is only suitable for medium sized deployments as it only supports 1,000,000 ip addresses
custom_replacements = {
  names = {
    # IP Ranges Primary
    # Regional Address Space: 172.16.0.0/16
    primary_hub_address_space                          = "172.16.0.0/22"
    primary_side_car_virtual_network_address_space     = "172.16.4.0/22"
    primary_bastion_subnet_address_prefix              = "172.16.4.0/26"
    primary_private_dns_resolver_subnet_address_prefix = "172.16.4.64/28"

    # IP Ranges Secondary
    # Regional Address Space: 172.17.0.0/16
    secondary_hub_address_space                          = "172.17.0.0/22"
    secondary_side_car_virtual_network_address_space     = "172.17.4.0/22"
    secondary_bastion_subnet_address_prefix              = "172.17.4.0/26"
    secondary_private_dns_resolver_subnet_address_prefix = "172.17.4.64/28"
  }
}

# Example of 192.168 IP ranges for a Virtual WAN
# NOTE that the 192.168 prefix is only suitable for a small, single region deployment as it only supports 65,000 ip addresses
custom_replacements = {
  names = {
    # IP Ranges Primary
    # Regional Address Space: 192.168.0.0/16
    primary_hub_address_space                          = "192.168.0.0/22"
    primary_side_car_virtual_network_address_space     = "192.168.4.0/22"
    primary_bastion_subnet_address_prefix              = "192.168.4.0/26"
    primary_private_dns_resolver_subnet_address_prefix = "192.168.4.64/28"
  }
}
{{< / highlight >}}
