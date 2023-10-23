data "azurerm_client_config" "current" {}

module "resource_group" {    
  source    = "../modules/resourcegroup"
  rg_name   = var.rg_name
  location  = var.location  
  tags      = var.tags
}

module "key_vault" {    
  source    = "../modules/keyvault"
  depends_on = [ module.resource_group ]
  kv_name   = var.kv_name
  rg_name   = var.rg_name
  location  = var.location  
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id
}

module "redis_instance" {
  source              = "../modules/redis"
  //resource_group_name = "vk-ade-rg"  # Provide the name of your existing resource group here
  resource_group_name = var.rg_name
  redis_name          = "db-redis-instance"
  sku_name            = "Standard"
  location  = var.location 
  capacity            = 2
  family              = "C"
  enable_non_ssl_port = true
}

