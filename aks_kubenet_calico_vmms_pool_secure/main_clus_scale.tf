resource "null_resource" "add_cluster_autoscale_p1" {
  count = "${var.ENABLE_CA_POOL1 ? 1 : 0}"

  depends_on = ["azurerm_kubernetes_cluster.main"]

  provisioner "local-exec" {
    command = "az aks nodepool update --enable-cluster-autoscaler -n ${var.POOL1_NAME} --min-count ${var.POOL1_MIN} --max-count ${var.POOL1_MAX}5 -g ${azurerm_resource_group.main.name} -n ${azurerm_kubernetes_cluster.main.name}"
    
    environment {
            AKS_NAME   = "${azurerm_kubernetes_cluster.main.name}"
            AKS_RG     = "${azurerm_resource_group.main.name}"
  }

 }   
}

resource "null_resource" "add_cluster_autoscale_p2" {
  count = "${var.ENABLE_CA_POOL2 ? 1 : 0}"
  depends_on = ["azurerm_kubernetes_cluster.main"]

  provisioner "local-exec" {
    command = "az aks nodepool update --enable-cluster-autoscaler -n ${var.POOL2_NAME} --min-count ${var.POOL2_MIN} --max-count ${var.POOL2_MAX}5 -g ${azurerm_resource_group.main.name} -n ${azurerm_kubernetes_cluster.main.name}"
    
    environment {
            AKS_NAME   = "${azurerm_kubernetes_cluster.main.name}"
            AKS_RG     = "${azurerm_resource_group.main.name}"
  }

 }   
}