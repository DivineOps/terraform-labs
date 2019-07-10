# Deploy the container registry

resource "azurerm_container_registry" "acr" {
  name     = "${var.prefix}-aks-rgacr"
  resource_group_name = "${azurerm_resource_group.test.name}"
  location            = "${azurerm_resource_group.test.location}"
  sku                 = "Standard"
  admin_enabled       = true
  
}