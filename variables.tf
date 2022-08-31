variable "subscription_id" {
    description = "Azure subscription ID"
}
variable "client_id" {
  description = "Azure Client ID"
}

variable "client_secret" {
  description = "Azure Client Secret"
}
variable "tenant_id" {
    description = "Azure tenant ID."
}
variable "location" {
  description = "Location of the azure resource group. Default is London."
  default = "northeurope"
}
variable "account_tier" {
  description = "Account Tier"
  default = "Standard"
}
# Find what's available: az vm list-skus -l northeurope --output table
variable "vm_size" {
  description = "VM Size, see https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage"
  default = "Standard_A1_v2"
}

variable "disk_size_gb" {
  description = "Size of the disk"
  default = 30
}

variable "agent_count" {
  description = "Number of agents (VMs) to host docker containers."
  default = 1
}
variable "admin_user" {
  description = "Administrative username for the VMs"
  default = "azureuser"
}
variable "ssh_key" {
  description = "SSH public key in PEM format to apply to VMs"
}
variable "account_replication_type" {
  description = "LRS etc."
  default = "LRS"
}
variable "backup_time" {
  description = "Time of day that backup will start"
  default = "23:00"
}
variable "retention_count" {
  description = "Number of backups to retain"
  default = "10"
}
variable "app_group" {
  description = "Label node for node affinity"
}
