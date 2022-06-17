
output "kube_config" {
  value = azurerm_kubernetes_cluster.default.kube_config_raw
}
output "host" {
  value = azurerm_kubernetes_cluster.default.kube_config.0.host
}
output "username" {
  value = azurerm_kubernetes_cluster.default.kube_config.0.username
}
output "password" {
  value = azurerm_kubernetes_cluster.default.kube_config.0.password
}
output "client_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
}
output "client_key" {
  value = base64decode(azurerm_kubernetes_cluster.default.kube_config.0.client_key)
}
output "cluster_ca_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)
}

output "azure_storage_account_key" {
  value = azurerm_storage_account.default.primary_access_key
}

output "azure_resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "azure_storage_account_name" {
  value = azurerm_storage_account.default.name
}

output "azure_storage_account_id" {
  value = azurerm_storage_account.default.id
}

output "azure_cluster_name" {
  value = azurerm_kubernetes_cluster.default.name
}

# output "sas_token" {
#   value = data.azurerm_storage_account_sas.default.sas
# }

output "azure_container_registry_name" {
  value = azurerm_container_registry.default.name
}

output "azure_container_registry_admin_username" {
  value = azurerm_container_registry.default.admin_username
}

output "azure_container_registry_admin_password" {
  value = azurerm_container_registry.default.admin_password
}

output "azure_cluster_node_resource_group" {
  value = azurerm_kubernetes_cluster.default.node_resource_group
}
