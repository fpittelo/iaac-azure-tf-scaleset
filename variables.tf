#
#All variables used on this project
#

# Azure Resource Group Name for the project
variable "rg_name" {
  default          = "iaac-azure-tf-vm"
  type             = string
  description      = "Azure Resource Group Name for the project"
}

# Variable defining the resource location
variable "rg_location" {
  default          = "Switzerland North"
  type             = string
  description      = "Azure Resource Group location for all items"
}