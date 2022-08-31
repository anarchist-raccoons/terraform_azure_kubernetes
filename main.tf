provider "azurerm" {
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id
  features {}
}

# Labels
module "labels" {
   source = "github.com/netflash/terraform-local-label"
#  source = "devops-workflow/label/local"
#  version = "0.2.1"

  # Required
  environment = var.environment
  name = var.name
  # Optional
  namespace-org = var.namespace-org
  organization = var.org
  delimiter = "-"
  owner = var.owner
  team = var.team
  tags = {
    Name = module.labels.id
  }
}

# Azure Resource Group
resource "azurerm_resource_group" "default" {
  name = module.labels.id
  location = var.location

  tags = module.labels.tags
}

# Kubernetes Cluster
resource "azurerm_kubernetes_cluster" "default" {
  name = module.labels.id
  location = var.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix = module.labels.name # @todo check this

  default_node_pool {
    name       = "default"
    node_count = var.agent_count
    vm_size    = var.vm_size
    os_disk_size_gb = var.disk_size_gb
    node_labels = {
      app_group = var.app_group
    }
  }
  
  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "basic"
  }
  
  linux_profile {
    admin_username = var.admin_user

    ssh_key {
      key_data = var.ssh_key
    }
  }
  
  lifecycle {
    ignore_changes = [
      role_based_access_control_enabled,
      default_node_pool  
    ]
  }

  service_principal {
    client_id = var.client_id
    client_secret = var.client_secret
  }
  
  tags = module.labels.tags
}
  
resource "random_string" "default" {
  length = 5
  special = false
  upper = false
}

# Storage Account
resource "azurerm_storage_account" "default" {
#  name = "${module.labels.organization}${module.labels.environment}${module.labels.name}"
  name = format("%s%s%s",module.labels.organization,module.labels.environment,module.labels.name)
  resource_group_name = azurerm_resource_group.default.name
  location = var.location
  account_tier = var.account_tier
  account_replication_type = var.account_replication_type
}

# Container Registry
resource "azurerm_container_registry" "default" {
  name = azurerm_storage_account.default.name
  resource_group_name = azurerm_resource_group.default.name
  location = var.location
  sku = var.account_tier
  admin_enabled = true # registry name as username, admin user access key as password for docker (alt to IAM beloe)
}

# Azure Share
resource "azurerm_storage_share" "default" {
#  name = "${module.labels.organization}${module.labels.environment}${module.labels.name}"
  name = format("%s%s%s",module.labels.organization,module.labels.environment,module.labels.name)

  storage_account_name = azurerm_storage_account.default.name
  quota = 5120
}

# Backup for Azure Share
#resource "azurerm_backup_container_storage_account" "protection-container" {
#  resource_group_name = azurerm_resource_group.default.name
#  recovery_vault_name = azurerm_recovery_services_vault.vault.name
#  storage_account_id  = azurerm_storage_account.default.id
#}

# Backup Azure Fileshare polict (not within terraform so we can persist our vaults beyond a terraform destroy)
#resource "azurerm_backup_policy_file_share" "default" {
#  name = "${module.labels.name}-recovery-vault-policy"
#  resource_group_name = azurerm_resource_group.default.name
#  recovery_vault_name = azurerm_recovery_services_vault.vault.name
#  
#  # Very simple daily backup for (defaults to 23:00 for 10 days)
#  backup {
#    frequency = "Daily"
#    time      = var.backup_time
#  }
#
#  retention_daily {
#    count = var.retention_count
#  }
#}

# Backup Azure Fileshare 
#resource "azurerm_backup_protected_file_share" "share1" {
#  resource_group_name       = azurerm_resource_group.default.name
#  recovery_vault_name       = azurerm_recovery_services_vault.vault.name
#  source_storage_account_id = azurerm_backup_container_storage_account.protection-container.storage_account_id
#  source_file_share_name    = azurerm_storage_share.default.name
#  backup_policy_id          = azurerm_backup_policy_file_share.default.id
#}
  

# Automation Account (used for start|stop)
#resource "azurerm_automation_account" "default" {
#  name = module.labels.id
#  resource_group_name = azurerm_resource_group.default.name
#  location = var.location
#  sku_name = "Basic"
##  sku {
##    name = "Basic"
##  }
#
#  tags = module.labels.tags
#}
  
# Log Analytics Workspace (used for start|stop)
#resource "azurerm_log_analytics_workspace" "default" {
#  name = module.labels.id
#  resource_group_name = azurerm_resource_group.default.name
#  location = var.location
#  sku                 = "PerGB2018"
#  retention_in_days   = 30
#}

# Storage Account Token
# data "azurerm_storage_account_sas" "default" {
#   connection_string = azurerm_storage_account.default.primary_connection_string
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

#   start = timestamp()
#   expiry = "${timeadd(
#     timestamp(), "360m"
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
