virtual_wan_virtual_hubs = {
  primary = {
    # Example hub network settings for this region
    hub = {
      name = "vwan-hub-$${starter_location_01}"
      resource_group = "$${connectivity_hub_primary_resource_group_name}"
      location       = "$${starter_location_01}"
      address_prefix = "$${primary_hub_address_space}"
    }
    # Example Azure Firewall settings for this region (omit this section if not using Azure Firewall)
    firewall = {
      name     = "fw-hub-$${starter_location_01}"
      sku_name = "AZFW_Hub"
      sku_tier = "Standard"
      zones    = "$${starter_location_01_availability_zones}"
    }
    # Example firewall policy settings for this region (omit this section if not using Azure Firewall)
    firewall_policy = {
      name = "fwp-hub-$${starter_location_01}"
    }
    # Example Virtual Network Gateway settings for this region (omit this section if not using Virtual Network Gateway)
    virtual_network_gateways = {
      # Example ExpressRoute settings for this region (omit this section if not using ExpressRoute)
      express_route = {
        name = "vgw-hub-expressroute-$${starter_location_01}"
      }
      # Example VPN Gateway settings for this region (omit this section if not using VPN Gateway)
      vpn = {
        name = "vgw-hub-vpn-$${starter_location_01}"
      }
    }
    # Example Private DNS Zone settings for this region (omit this section if not using Private DNS Zones)
    private_dns_zones = {
      resource_group_name            = "$${dns_resource_group_name}"
      is_primary                     = true
      auto_registration_zone_enabled = true
      auto_registration_zone_name    = "$${starter_location_01}.azure.local"
      subnet_address_prefix          = "$${primary_private_dns_resolver_subnet_address_prefix}"
      private_dns_resolver = {
        name = "pdr-hub-dns-$${starter_location_01}"
      }
    }
    # Example Bastion Host settings for this region (omit this section if not using Bastion Host)
    bastion = {
      subnet_address_prefix = "$${primary_bastion_subnet_address_prefix}"
      bastion_host = {
        name = "bastion-hub-$${starter_location_01}"
      }
      bastion_public_ip = {
        name  = "pip-bastion-hub-$${starter_location_01}"
        zones = "$${starter_location_01_availability_zones}"
      }
    }
    # Example Side Car Virtual Network settings for this region
    side_car_virtual_network = {
      name          = "vnet-side-car-$${starter_location_01}"
      address_space = ["$${primary_side_car_virtual_network_address_space}"]
    }
  }
}
