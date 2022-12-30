#
#All variables used on this project
#

# Azure Resource Group Name for the project
variable "rg_name" {
  default          = "iaac-azure-tf-scaleset"
  type             = string
  description      = "Azure Resource Group Name for the project"
}

# Variable defining the resource location
variable "rg_location" {
  default          = "Switzerland North"
  type             = string
  description      = "Azure Resource Group location for all items"
}

# Variable defining vnet name
variable "vnet_name" {
  default          = "vnet"
  type             = string
  description      = "Variable defining vnet name"
}

# Variable defining internal subnet name
variable "subnetint_name" {
  default          = "subnet-int"
  type             = string
  description      = "Variable defining vnet name"
}

# Variable defining the test scale set name
variable "vm_scaleset_test" {
  default          = "vm-scaleset-test"
  type             = string
  description      = "Variable defining the test scale set"
}