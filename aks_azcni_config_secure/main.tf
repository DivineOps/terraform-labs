# Configure the Microsoft Azure Provider
provider "azurerm" {
  version = "~>1.30.1"
  # subscription_id = "insert-guid-here"
  # client_id       = "insert-guid-here"
  # client_secret   = "insert-secret-here"
  # tenant_id       = "insert-guid-here"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}-rg"
  location = "${var.REGION}"

  tags = {
    project = "${var.PROJECT}"
    instance = "${var.INSTANCE}"
    environment = "${var.ENVIRONMENT}"
  }
}

resource "random_integer" "uuid" { 
  min = 100
  max = 999
}

