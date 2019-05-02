provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
}

# Labels
module "labels" {
  source = "devops-workflow/label/local"
  version = "0.2.1"

  # Required
  environment = "${var.environment}"
  name = "${var.name}"
  # Optional
  namespace-org = "${var.namespace-org}"
  organization = "${var.org}"
  delimiter = "-"
  owner = "${var.owner}"
  team = "${var.team}"
  tags {
    Name = "${module.labels.id}"
  }
}

# Azure Resource Group
resource "azurerm_resource_group" "default" {
  name = "${module.labels.id}"
  location = "${var.location}"

  tags = "${module.labels.tags}"
}

# Kubernetes Cluster
resource "azurerm_kubernetes_cluster" "default" {
  name = "${module.labels.id}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  dns_prefix = "${module.labels.name}" # @todo check this

  linux_profile {
    admin_username = "${var.admin_user}"

    ssh_key {
      key_data = "${var.ssh_key}"
    }
  }

  agent_pool_profile {
    name = "default"
    count = "${var.agent_count}"
    vm_size = "${var.vm_size}"
    os_type = "Linux"
    os_disk_size_gb = "${var.disk_size_gb}"
  }

  service_principal {
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags = "${module.labels.tags}"
}

# Storage Account
resource "azurerm_storage_account" "default" {
  name = "${module.labels.organization}${module.labels.environment}${module.labels.name}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  location = "${var.location}"
  account_tier = "${var.account_tier}"
  account_replication_type = "${var.account_replication_type}"
}

# Container Registry
resource "azurerm_container_registry" "default" {
  name = "${azurerm_storage_account.default.name}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  location = "${var.location}"
  sku = "${var.account_tier}"
  admin_enabled = true # registry name as username, admin user access key as password for docker (alt to IAM beloe)
}

# Azure Share
resource "azurerm_storage_share" "default" {
  name = "${module.labels.organization}${module.labels.environment}${module.labels.name}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  storage_account_name = "${azurerm_storage_account.default.name}"
}

# Automation Account (used for start|stop)
resource "azurerm_automation_account" "default" {
  name = "${module.labels.id}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  location = "${var.location}"
  sku {
    name = "Basic"
  }

  tags = "${module.labels.tags}"
}

# Storage Account Token
# data "azurerm_storage_account_sas" "default" {
#   connection_string = "${azurerm_storage_account.default.primary_connection_string}"
#   https_only = false

#   resource_types {
#     service = true
#     container = true
#     object = true
#   }

#   services {
#     blob = false
#     queue = false
#     table = false
#     file = true
#   }

#   start = "${timestamp()}"
#   expiry = "${timeadd(
#     "${timestamp()}", "360m"
#     )}"

#   permissions {
#     read = true
#     write = true
#     delete = false
#     list = true
#     add = true
#     create = true
#     update = true
#     process = true
#   }
# }
