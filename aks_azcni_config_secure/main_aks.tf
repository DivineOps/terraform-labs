# service principal for aks

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}aks"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  dns_prefix          = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}"
  kubernetes_version  = "${var.K8S_VER}"

  depends_on = [
   "azurerm_role_assignment.aks-network-contributor",
   "azurerm_subnet.akssubnet",
   "azurerm_firewall.hubazfw"]

  linux_profile {
    admin_username = "${var.ADMIN_USER}"

    ssh_key {
      key_data = "${var.AKS_SSH_ADMIN_KEY}"
    }
  }

  agent_pool_profile {
    name            = "istiopool"
    type            = "VirtualMachineScaleSets"
    count           = "${var.NODE_COUNT}"
    vm_size         = "${var.NODE_SIZE}"
    os_type         = "Linux"
    os_disk_size_gb = 30
    vnet_subnet_id  = "${azurerm_subnet.akssubnet.id}"
  }
  agent_pool_profile {
    name            = "workerpool"
    type            = "VirtualMachineScaleSets"
    count           = "${var.NODE_COUNT}"
    vm_size         = "${var.NODE_SIZE}"
    os_type         = "Linux"
    os_disk_size_gb = 30
    vnet_subnet_id  = "${azurerm_subnet.akssubnet.id}"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    service_cidr = "${var.SERVICE_CIDR}"
    dns_service_ip = "${var.DNS_IP}"
    docker_bridge_cidr = "${var.DOCKER_CIDR}"
    #pod_cidr = "${var.POD_CIDR}"
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      # NOTE: in a Production environment these should be different values
      # but for the purposes of this example, this should be sufficient
      client_app_id = "${var.AAD_CLIENTAPP_ID}"

      server_app_id     = "${var.AAD_SERVERAPP_ID}"
      server_app_secret = "${var.AAD_SERVERAPP_SECRET}"
    }
  }

  service_principal {
    client_id     = "${azuread_application.akssp.application_id}"
    client_secret = "${azuread_service_principal_password.akssp.value}"
  }

  # api_server_authorized_ip_ranges = [
  #   "100.200.0.0/14",
  #   "72.183.132.114/32",
  #   "${azurerm_public_ip.azfwpip.ip_address}/32"
  # ]
}