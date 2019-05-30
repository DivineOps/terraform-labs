resource "azurerm_eventhub_namespace" "eh" {
  name                = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}-ehnamespace"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  sku                 = "Standard"
  capacity            = 2
  kafka_enabled       = true

  tags = {
    environment = "Examples"
  }
}

resource "azurerm_eventhub_namespace_authorization_rule" "eh" {
  name                = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}-nsauth-rule"
  namespace_name      = "${azurerm_eventhub_namespace.eh.name}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  listen = true
  send   = true
  manage = false
}

resource "azurerm_eventhub" "eh" {
  name                = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}-eh1"
  namespace_name      = "${azurerm_eventhub_namespace.eh.name}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  partition_count   = 2
  message_retention = 1
}

resource "azurerm_eventhub_authorization_rule" "eh" {
  name                = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}-enauth-rule"
  namespace_name      = "${azurerm_eventhub_namespace.eh.name}"
  eventhub_name       = "${azurerm_eventhub.eh.name}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  listen = true
  send   = true
  manage = true
}

resource "azurerm_eventhub_consumer_group" "eh" {
  name                = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}-ehcg"
  namespace_name      = "${azurerm_eventhub_namespace.eh.name}"
  eventhub_name       = "${azurerm_eventhub.eh.name}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  user_metadata       = "some-meta-data"
}