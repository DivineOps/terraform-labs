resource "azurerm_virtual_network" "aksvnet" {
  name                = "${var.VNET_NAME}"
  location            = "${azurerm_resource_group.main.location}"
  address_space       = ["${var.VNET_ADDR_SPACE}"]
  resource_group_name = "${azurerm_resource_group.main.name}"
  dns_servers         = "${var.DNS_SERVERS}"
}

resource "azurerm_subnet" "akssubnet" {
  name                      = "${var.SUBNET_NAMES[count.index]}"
  virtual_network_name      = "${azurerm_virtual_network.aksvnet.name}"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  address_prefix            = "${var.SUBNET_PREFIXES[count.index]}"
  count                     = "${length(var.SUBNET_NAMES)}"
  route_table_id            = "${azurerm_route_table.vdmzudr.id}"
}