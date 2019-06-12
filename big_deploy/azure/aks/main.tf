module "azure-provider" {
    source = "../provider"
}

resource "azurerm_resource_group" "cluster" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.cluster.location}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  dns_prefix          = "${var.dns_prefix}"
  kubernetes_version  = "${var.kubernetes_version}"

  linux_profile {
    admin_username = "${var.admin_user}"

    ssh_key {
      key_data = "${var.ssh_public_key}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_vm_count}"
    vm_size         = "${var.agent_vm_size}"
    os_type         = "Linux"
    os_disk_size_gb = 30
    vnet_subnet_id  = "${var.vnet_subnet_id}"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr = "${var.service_cidr}"
    dns_service_ip = "${var.dns_ip}"
    docker_bridge_cidr = "${var.docker_cidr}"
  }

  role_based_access_control {
    enabled = true
  }

  service_principal {
    client_id     = "${var.service_principal_id}"
    client_secret = "${var.service_principal_secret}"
  }
}

# kube config and helm init
resource "local_file" "kube_config" {
  # kube config
  filename = "${var.kube_config_path}"
  content  = "${azurerm_kubernetes_cluster.cluster.kube_config_raw}"

  # helm init
  provisioner "local-exec" {
    command = "helm init --client-only"
    environment {
      KUBECONFIG = "${var.kube_config_path}"
      HELM_HOME  = "${var.helm_home_path}"
    }
  }
}