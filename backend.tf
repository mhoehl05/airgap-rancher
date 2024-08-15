terraform {
  cloud {
    organization = "cw_playground_mhoehl"

    workspaces {
      name = "rancher-demo"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}