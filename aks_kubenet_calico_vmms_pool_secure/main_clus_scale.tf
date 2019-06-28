resource "null_resource" "add_cluster_autoscale_p1" {
  count = "${var.ENABLE_CA_POOL1 ? 1 : 0}"

  depends_on = ["azurerm_kubernetes_cluster.main"]

  provisioner "local-exec" {
    command = "az aks nodepool update --enable-cluster-autoscaler -n ${var.POOL1_NAME} --min-count ${var.POOL1_MIN} --max-count ${var.POOL1_MAX} -g ${azurerm_resource_group.main.name} --cluster-name ${azurerm_kubernetes_cluster.main.name}"
    
  }
  provisioner "local-exec" {
    when = "destroy"
    command = "az aks nodepool update --disable-cluster-autoscaler -n ${var.POOL1_NAME} -g ${azurerm_resource_group.main.name} --cluster-name ${azurerm_kubernetes_cluster.main.name}"
    
  }     
}

resource "null_resource" "add_cluster_autoscale_p2" {
  count = "${var.ENABLE_CA_POOL2 ? 1 : 0}"
  depends_on = ["azurerm_kubernetes_cluster.main"]

  provisioner "local-exec" {
    command = "az aks nodepool update --enable-cluster-autoscaler -n ${var.POOL2_NAME} --min-count ${var.POOL2_MIN} --max-count ${var.POOL2_MAX} -g ${azurerm_resource_group.main.name} --cluster-name ${azurerm_kubernetes_cluster.main.name}"

  }

  provisioner "local-exec" {
    when = "destroy"
    command = "az aks nodepool update --disable-cluster-autoscaler -n ${var.POOL2_NAME} -g ${azurerm_resource_group.main.name} --cluster-name ${azurerm_kubernetes_cluster.main.name}"
    
  }
}