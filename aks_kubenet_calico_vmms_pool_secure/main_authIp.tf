resource "null_resource" "authIPInstall" {
  
  provisioner "local-exec" {
        command = "az extension add --name aks-preview"
    }

  provisioner "local-exec" {
    command = "az aks update --api-server-authorized-ip-ranges ${var.AUTH_IP_RANGES},${azurerm_public_ip.azfwpip.ip_address}/32 -g ${azurerm_resource_group.main.name} -n ${azurerm_kubernetes_cluster.main.name}"

  }

provisioner "local-exec" {
    command = "az aks update -g ${azurerm_resource_group.main.name} -n ${azurerm_kubernetes_cluster.main.name} --enable-pod-security-policy"

  }

}
