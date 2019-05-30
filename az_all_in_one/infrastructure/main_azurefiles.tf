resource "azurerm_storage_account" "azurefile" {
  name                     = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}stor"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "azurefile" {
  name                 = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}-share"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  storage_account_name = "${azurerm_storage_account.azurefile.name}"
  quota                = 50
}
