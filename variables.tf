variable "prefix" {
  description = "A prefix used for all resources in this example"
  default = "reactapp"
  type = string
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default = "East US"
  type = string
}

variable "ARM_SUBSCRIPTION_ID" {
}

variable "ARM_CLIENT_ID" {
}

variable "ARM_CLIENT_SECRET" {
}

variable "ARM_TENANT_ID" {
}
variable "ARM_ENV" {
}

variable "ARM_ACR" {
}

variable "ARM_ACR_ID" {
}
variable "ARM_REPOSITORY" {
}

variable "build_tag" {
  type = string
}