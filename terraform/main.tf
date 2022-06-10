terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.2.5"
    }
    azurerm = {
      version = "2.29.0"
    }
  }
}



provider "azurerm" {
    features {}
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.myworkspace.id
}


resource "azurerm_resource_group" "myresourcegroup" {
  name     = "resource1006v01myresourcegroup"
  location = var.location
}

resource "azurerm_databricks_workspace" "myworkspace" {
  location                      = azurerm_resource_group.myresourcegroup.location
  name                          = "muffin1006v01workspace"
  resource_group_name           = azurerm_resource_group.myresourcegroup.name
  sku                           = "trial"
}

resource "databricks_scim_user" "admin" {
  user_name    = "admin@example.com"
  display_name = "Admin user"
  set_admin    = true
  default_roles = []
}


resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = "${var.prefix}-Autoscaling-Cluster"
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  autotermination_minutes = 30
  autoscale {
    min_workers = var.min_workers
    max_workers = var.max_workers
  }
  library {
    pypi {
        package = "scikit-learn==0.23.2"
        // repo can also be specified here
        }

    }
  library {
    pypi {
        package = "pystan==2.19.1.1"
        // repo can also be specified here
        }

    }
  library {
    pypi {
        package = "fbprophet==0.6"
        }
  }
  custom_tags = {
    Department = "Engineering"
  }
}

resource "databricks_notebook" "notebook" {
  content = var.notebook_path
  path = var.notebook_path
  overwrite = false
  mkdirs = true
  language = "PYTHON"
  format = "SOURCE"
  
}
