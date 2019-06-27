resource "azuread_application" "akssp" {
  name = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}-aks"
}

resource "azuread_service_principal" "akssp" {
  application_id = "${azuread_application.akssp.application_id}"
}

resource "random_string" "akssp_rnd" {
  length  = 32
  special = true
}

resource "azuread_service_principal_password" "akssp" {
  service_principal_id = "${azuread_service_principal.akssp.id}"
  value                = "${random_string.akssp_rnd.result}"
  end_date_relative    = "17520h"
}

resource "azurerm_role_assignment" "aks-network-contributor" {
  scope                = "${azurerm_resource_group.main.id}"
  role_definition_name = "Network Contributor"
  principal_id         = "${azuread_service_principal.akssp.id}"
}
