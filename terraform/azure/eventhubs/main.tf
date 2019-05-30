resource "azurerm_resource_group" "eh" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

resource "azurerm_eventhub_namespace" "eh" {
  name                = "${var.prefix}-ehnamespace"
  location            = "${azurerm_resource_group.eh.location}"
  resource_group_name = "${azurerm_resource_group.eh.name}"
  sku                 = "Standard"
  capacity            = 2
  kafka_enabled       = true

  tags = {
    environment = "Examples"
  }
}

resource "azurerm_eventhub_namespace_authorization_rule" "eh" {
  name                = "${var.prefix}-nsauth-rule"
  namespace_name      = "${azurerm_eventhub_namespace.eh.name}"
  resource_group_name = "${azurerm_resource_group.eh.name}"

  listen = true
  send   = true
  manage = false
}

resource "azurerm_eventhub" "eh" {
  name                = "${var.prefix}-eh1"
  namespace_name      = "${azurerm_eventhub_namespace.eh.name}"
  resource_group_name = "${azurerm_resource_group.eh.name}"

  partition_count   = 2
  message_retention = 1
}

resource "azurerm_eventhub_authorization_rule" "eh" {
  name                = "${var.prefix}-enauth-rule"
  namespace_name      = "${azurerm_eventhub_namespace.eh.name}"
  eventhub_name       = "${azurerm_eventhub.eh.name}"
  resource_group_name = "${azurerm_resource_group.eh.name}"

  listen = true
  send   = true
  manage = true
}

resource "azurerm_eventhub_consumer_group" "eh" {
  name                = "${var.prefix}-ehcg"
  namespace_name      = "${azurerm_eventhub_namespace.eh.name}"
  eventhub_name       = "${azurerm_eventhub.eh.name}"
  resource_group_name = "${azurerm_resource_group.eh.name}"
  user_metadata       = "some-meta-data"
}