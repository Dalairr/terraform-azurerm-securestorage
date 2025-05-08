terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.43.0"
    }
  }
}

# Local variable for tagging resources consistently
locals {
  tags = {
    "Environment" = var.environment
  }
}

# This module defines a secure Azure Storage Account
resource "azurerm_storage_account" "securestorage" {
  resource_group_name           = var.resource_group_name
  location                      = var.location
  name                          = var.storage_account_name
  account_tier                  = "Standard"
  
  # Conditional logic: use GRS for Production, LRS for anything else
  account_replication_type      = var.environment == "Production" ? "GRS" : "LRS"
  
  # Disable public access for security
  public_network_access_enabled = false

  # Apply tags
  tags = local.tags
}
