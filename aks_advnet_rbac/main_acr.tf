# Deploy the container registry

resource "azurerm_container_registry" "acr" {
  name     = "${var.PREFIX}aksacr"
  resource_group_name = "${azurerm_resource_group.test.name}"
  location            = "${azurerm_resource_group.test.location}"
  sku                 = "Standard"
  admin_enabled       = true
  
}