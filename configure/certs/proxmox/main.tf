########################################################
#             Vault Provider details
########################################################
terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "5.2.1"
    }
  }
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

##################################################################
#                 Generate Certs
# Ref : https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_cert
##################################################################

resource "vault_pki_secret_backend_cert" "cert" {
  backend     = var.backend
  name        = var.role_name
  common_name = var.cert_common_name
  ip_sans     = var.cert_ip_sans
  revoke      = var.revoke
}

##################################################################
#         Save Certs locally inside certs/
##################################################################

resource "local_sensitive_file" "private_key" {
  content  = vault_pki_secret_backend_cert.cert.private_key
  filename = "certs/${var.cert_file_name}.key"
}

resource "local_file" "certificate" {
  content  = vault_pki_secret_backend_cert.cert.certificate
  filename = "certs/${var.cert_file_name}.crt"
}

resource "local_file" "issuing_ca" {
  content  = vault_pki_secret_backend_cert.cert.issuing_ca
  filename = "certs/issuing_ca.crt"
}

resource "local_file" "ca_chain" {
  content  = vault_pki_secret_backend_cert.cert.ca_chain
  filename = "certs/ca_chain.crt"
}