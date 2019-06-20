# data "azurerm_virtual_network" "hub" {
#   name                = "${azurerm_virtual_network.hubvnet}"
#   resource_group_name = "${azurerm_resource_group.main.name}"
#   location            = "${azurerm_resource_group.main.location}"
# }


resource "azurerm_virtual_network_peering" "first-to-second" {
  name                         = "first-to-second"
  resource_group_name          = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name         = "${azurerm_virtual_network.hubvnet.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.aksvnet.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "second-to-first" {
  name                         = "second-to-first"
  resource_group_name          = "${azurerm_resource_group.main.name}"
  virtual_network_name         = "${azurerm_virtual_network.aksvnet.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.hubvnet.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}