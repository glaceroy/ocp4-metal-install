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

########################################################
#             Role for server certs
########################################################
resource "vault_pki_secret_backend_role" "role-server-cer" {
  backend = vault_mount.pki_int.path
  name = "issue-certs-for-${var.server_cert_domain}"
  allowed_domains = [ var.server_cert_domain ]
  allow_subdomains = true
  allow_glob_domains = false
  allow_any_name = false
  enforce_hostnames = true
  allow_ip_sans = true
  server_flag = true
  client_flag = false 
  ou = ["Cloud Security"]
  organization = ["Cloud Lab"]
  locality = ["Warrington"]
  province = ["Cheshire"]
  country = ["UK"]
  # 2 years
  max_ttl = 63113904 
  # 30 days
  ttl = 2592000
  no_store = false

}
