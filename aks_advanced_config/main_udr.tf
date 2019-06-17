resource "azurerm_route_table" "vdmzudr" {
  name                = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}routetable"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  depends_on = ["azurerm_firewall.hubazfw"]

  route {
    name                   = "vDMZ"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${azurerm_firewall.hubazfw.private_ip_address}"
  }
}

resource "azurerm_subnet_route_table_association" "vdmzudr" {
  subnet_id      = "${azurerm_subnet.akssubnet.id}"
  route_table_id = "${azurerm_route_table.vdmzudr.id}"
}