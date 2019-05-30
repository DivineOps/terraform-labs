resource "azurerm_resource_group" "azurefile" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

resource "azurerm_storage_account" "azurefile" {
  name                     = "${var.prefix}stor"
  resource_group_name      = "${azurerm_resource_group.azurefile.name}"
  location                 = "${azurerm_resource_group.azurefile.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "azurefile" {
  name                 = "${var.prefix}-share"
  resource_group_name  = "${azurerm_resource_group.azurefile.name}"
  storage_account_name = "${azurerm_storage_account.azurefile.name}"
  quota                = 50
}
