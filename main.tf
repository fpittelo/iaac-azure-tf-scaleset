#
#
# Main Terraform file for the project
#
locals {
  first_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDA/KD+sKBIejh4eWVtJ0Dbe8J/fH48FcIr+bweSCsC1nOQ1Ia6w3wiji8dbd2ZEV7XbS2EeEBSE/IG55/uAW3N3mk7V1MDFBa4U6piXZZzDzGh7EwcHO2m5qpBbiP+2bq1+7BA7ce+TlCgtilpbvMJaLYnWYcaQmHBSX4d9NLoHu2u0lNd27W2dJzWJD+qHOw4NnW/EbzfUsV6tQ74cVLs/ZrRI92dZhhB4o8BbhrKlL/3ZmbVOv0kPOEcQ/mkGxccVdJiN0J66tvPuTziK8nZVSlqfQnI05PXNmKt+o3GWKelON513ZNzrFgTQZqDMfSsDfBMrXAkWFNkV0B5dwqOHImddI3JJTuksTzXgGqf7pkS6upX0Gi64Iw6qT5z3BURg5JW/jTqq6K2vvCfnvrRSPBi8dME9pIYBhHBbLnRreNF8aq28IjzwhI13lXT0AdBZlLd7lGEIqKcey93CiPK8jL4RHlLlGgTy4ddEZhTVHh+lXw++4rzp0AticDgz9R+SOxmuEBbb2bG0oIsoXRDnH7kKN2tIcT8GuyRC0r6inBqXGwcmJOpWECYLy6p06LpIHLXkIInWG9/is5Mo0i1qoH0qJ7pVNDaPfKVSxI4S0kObrG5a6cRYd3YNxVE4CXzObzjOGhrYkzcRwKbgiQFqw6nCJzgMb4Je/uQ2r+Tbw== fred@MJOLNIR"
}

resource "azurerm_resource_group" "rg" {
  name                = var.rg_name
  location            = var.rg_location
  
  tags = {
    department                = var.vm_dpt_it
    environment               = var.vm_env_test
    owner                     = var.vm_owner
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  address_space       = ["10.0.0.0/16"]
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "subint" {
  name                 = var.subnetint_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_resource_group.rg, azurerm_virtual_network.vnet ]
}

resource "azurerm_linux_virtual_machine_scale_set" "vm_scaleset" {
  name                = var.vm_scaleset_test
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = "Standard_F2"
  instances           = 2
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
  # public_key = file("~/.ssh/fredkey.pub")
    public_key = local.first_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmnic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.subint.id
    }
  }
}