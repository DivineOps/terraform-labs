resource "azuread_application" "test" {
  name = "${var.PREFIX}-app"
}

resource "azuread_service_principal" "test" {
  application_id = "${azuread_application.test.application_id}"
}

resource "random_string" "password" {
  length  = 32
  special = true
}

resource "azuread_service_principal_password" "test" {
  service_principal_id = "${azuread_service_principal.test.id}"
  value                = "${random_string.password.result}"
  end_date             = "2099-01-01T01:00:00Z"
}

resource "azurerm_role_assignment" "test" {
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/${azurerm_resource_group.test.name}"
  role_definition_name = "Network Contributor"
  principal_id         = "${azuread_service_principal.test.id}"
}