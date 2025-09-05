########################################################
#             Vault Provider Details
########################################################
variable "vault_address" {
  description = "The address of the Vault server"
  type        = string
  default     = "http://192.168.0.25:8200/"
}

variable "vault_token" {
  description = "The token to authenticate with Vault"
  type        = string
}

########################################################
#             Vault Certificate Details
########################################################
variable "cert_domain" {
    description = "We create a role to create certs, what DNS domain will these certs be in"
    default = "cloud.lab"
}