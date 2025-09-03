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
variable "server_cert_domain" {
    description = "We create a role to create server certs, what DNS domain will these certs be in"
    default = "home"
}
variable "client_cert_domain" {
    description = "Allowed Domains for Client Cert"
    default = "home"
}