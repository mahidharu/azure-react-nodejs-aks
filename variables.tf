variable "prefix" {
  description = "A prefix used for all resources in this example"
  default = "reactapp"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default = "East US"
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