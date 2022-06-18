
output "kube_config" {
  value = azurerm_kubernetes_cluster.default.kube_config_raw
  sensitive = true
}
output "host" {
  value = azurerm_kubernetes_cluster.default.kube_config.0.host
  sensitive = true
}
output "username" {
  value = azurerm_kubernetes_cluster.default.kube_config.0.username
  sensitive = true
}
output "password" {
  value = azurerm_kubernetes_cluster.default.kube_config.0.password
  sensitive = true
}
output "client_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
  sensitive = true
}
output "client_key" {
  value = base64decode(azurerm_kubernetes_cluster.default.kube_config.0.client_key)
  sensitive = true
}
output "cluster_ca_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)
  sensitive = true
}

output "azure_storage_account_key" {
  value = azurerm_storage_account.default.primary_access_key
  sensitive = true
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
  sensitive = true
}

output "azure_cluster_node_resource_group" {
  value = azurerm_kubernetes_cluster.default.node_resource_group
}
