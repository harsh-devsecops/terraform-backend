terraform{
backend "azurerm" {
    
    resource_group_name  = "example2"
    storage_account_name = "dso456108"
    container_name       = "stfstate"
    key                  = "akterraform.tfstate"
  }
}
