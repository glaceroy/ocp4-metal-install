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
#             Cert Variables
########################################################

variable "cert_file_name" {
  description = "The name of the certificate"
  type        = string
  default     = "ingress"
}

variable "backend" {
  description = "The PKI backend to use"
  type        = string
  default     = "pki-intermediate-ca"
}

variable "role_name" {
  description = "The role name to use for issuing the certificate"
  type        = string
  default     = "issue-certs-for-cloud.lab"
}

variable "cert_common_name" {
  description = "The common name for the certificate"
  type        = string
  default     = "ocp.cloud.lab"
}

variable "alt_names" {
  description = "The Subject Alternative Names for the certificate"
  type        = list(string)
  default     = ["*.apps.ocp.cloud.lab"]
}
variable "cert_ip_sans" {
  description = "The IP Subject Alternative Names for the certificate"
  type        = list(string)
  default     = ["192.168.0.42"]  
}

variable "revoke" {
  description = "Whether to revoke the certificate if it already exists"
  type        = bool
  default     = true
}