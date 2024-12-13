virtual_wan_settings = {
  name                = "vwan-$${starter_location_01}"
  resource_group_name = "$${connectivity_hub_vwan_resource_group_name}"
  location            = "$${starter_location_01}"
  ddos_protection_plan = {
    name                = "$${ddos_protection_plan_name}"
    resource_group_name = "$${ddos_resource_group_name}"
    location            = "$${starter_location_01}"
  }
}
