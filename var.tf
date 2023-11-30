variable "rg_name" {
  type        = any
  default     = "example"
  description = "The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
}
variable "rg_location" {
  type        = string
  # default     = "North Europe"
  description = "The location/region where the virtual network is created."
}
variable "sa_name" {
  type        = string
  //default     = "harsh07"
  description = "The name of azurerm_storage_account"
}
variable "sa_account_tier" {
  type        = string
  //default     = "Standard"
  description = "Defines the Tier to use for this storage account"
}
variable "account_replication_type" {
  type        = string
  //default     = "LRS"
  description = "Defines the type of replication to use for this storage account"
}
variable "sc_name" {
  type        = string
  
  description = "The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created"
}
variable "container_access_type" {
  type        = string
  
  description = "The Access Level configured for this Container"
}

