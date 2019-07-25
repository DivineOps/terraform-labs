# Configure the Microsoft Azure Provider

terraform {

  backend "azurerm" {

    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"

    # access_key = Do not put the secret in the repo! Use the ARM_ACCESS_KEY environment variable instead!
  }
}

provider "azurerm" {

  version = "~>1.30.1"
  # Use environment variables for secrets and GUIDs

}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "test" {
  name     = "${var.PREFIX}-aks-rg"
  location = "${var.LOCATION}"
}

resource "azurerm_policy_assignment" "test" {
  name                 = "location-policy-assignment"
  scope                = "${azurerm_resource_group.test.id}"
  policy_definition_id = "${azurerm_policy_definition.test.id}"
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Location Policy Assignment"
  # depends_on           = [azurerm_resource_group.test]

  parameters = <<PARAMETERS
  {
    "allowedLocations": {
      "value": [ "${var.LOCATION}" ]
    }
  }
PARAMETERS
}

#Uncomment below if you need a Route Table (UDR) to route to an Netwokr Virtual Appliamce (Palo Alto, F5, Barricuda, Cisco ASR, etc) in a peered VNET
# resource "azurerm_route_table" "test" {
#   name                = "${var.PREFIX}-routetable"
#   location            = "${azurerm_resource_group.test.location}"
#   resource_group_name = "${azurerm_resource_group.test.name}"

#   route {
#     name                   = "default"
#     address_prefix         = "10.100.0.0/14"
#     next_hop_type          = "VirtualAppliance"
#     next_hop_in_ip_address = "10.10.1.1"
#   }
# }

# resource "azurerm_log_analytics_workspace" "test" {
#   name                = "${var.PREFIX}-law"
#   location            = "${azurerm_resource_group.test.location}"
#   resource_group_name = "${azurerm_resource_group.test.name}"
#   sku                 = "Free"
# }

# resource "azurerm_log_analytics_solution" "test" {
#   solution_name         = "ContainerInsights"
#   location              = "${azurerm_resource_group.test.location}"
#   resource_group_name   = "${azurerm_resource_group.test.name}"
#   workspace_resource_id = "${azurerm_log_analytics_workspace.test.id}"
#   workspace_name        = "${azurerm_log_analytics_workspace.test.name}"

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/ContainerInsights"
#   }
# }

resource "azurerm_virtual_network" "test" {
  name                = "${var.PREFIX}-network"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  address_space       = ["${var.vnetIPCIDR}"]
}

resource "azurerm_subnet" "test" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  address_prefix       = "${var.subnetIPCIDR}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  #Uncomment if Route Table was created above. 
  # this field is deprecated and will be removed in 2.0 - but is required until then
#  route_table_id = "${azurerm_route_table.test.id}"
}

#Uncomment if Route Table was created above. 
# resource "azurerm_subnet_route_table_association" "test" {
#   subnet_id      = "${azurerm_subnet.test.id}"
#   route_table_id = "${azurerm_route_table.test.id}"
# }

resource "azurerm_kubernetes_cluster" "test" {
  name                = "${var.PREFIX}-aks"
  location            = "${azurerm_resource_group.test.location}"
  dns_prefix          = "${var.PREFIX}-aks"
  resource_group_name = "${azurerm_resource_group.test.name}"
  kubernetes_version = "${var.k8sVer}"

  linux_profile {
    admin_username = "${var.osAdminUser}"

    ssh_key {
      key_data = "${var.ADMIN_SSH}"
    }
  }

  agent_pool_profile {
    name            = "agentpool"
    count           = "${var.nodeCount}"
    vm_size         = "${var.nodeSize}"
    os_type         = "Linux"
    os_disk_size_gb = 30

    # Required for advanced networking
    vnet_subnet_id = "${azurerm_subnet.test.id}"
  }

  service_principal {
    # Used for the AKS cluster
    client_id     = "${var.ARM_CLIENT_ID}"	    
    client_secret = "${var.ARM_CLIENT_SECRET}"
  }

  role_based_access_control {
    enabled = true
  }

  # addon_profile {
  #   oms_agent {
  #     enabled                    = true
  #     log_analytics_workspace_id = "${azurerm_log_analytics_workspace.test.id}"
  #   }
  # }

  network_profile {
    network_plugin = "${var.netPlugin}"
    service_cidr = "${var.svc-cidr}"
    dns_service_ip = "${var.dns-ip}"
    docker_bridge_cidr = "${var.dockerbridge-cidr}"
    # pod_cidr = "${var.pod-cidr}"
  }
}
