/*
 * Kubernetes
 */

output "AKS_RESOURCE_GROUP" {
  value = "${azurerm_resource_group.main.name}"
  description = "The main resource group of the AKS Resource"
}
output "AKS_SP_APPID" {
  value = "${azuread_application.akssp.application_id}"
}
