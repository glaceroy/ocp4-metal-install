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
  backend = vault_mount.pki_intermediate.path
  name = "server-cert-for-${var.server_cert_domain}"
  allowed_domains = [ var.server_cert_domain ]
  allow_subdomains = true
  allow_glob_domains = false
  allow_any_name = false
  enforce_hostnames = true
  allow_ip_sans = true
  server_flag = true
  client_flag = false 
  ou = ["cloud security"]
  organization = ["cloud lab"]
  country = ["uk"]
  locality = ["warrington"]
  # 2 years
  max_ttl = 63113904 
  # 30 days
  ttl = 2592000
  no_store = false

}
resource "vault_pki_secret_backend_role" "vault-client-cert" {
  backend = vault_mount.pki_intermediate.path
  name = "client-cert-for-${var.client_cert_domain}"
  allowed_domains = [ var.client_cert_domain ]
  allow_subdomains = false
  allow_glob_domains = false
  allow_bare_domains = true # needed for email address verification
  allow_any_name = false 
  enforce_hostnames = true
  allow_ip_sans = true
  #allowed_other_sans = ["1.2.840.113549.1.9.1;utf8:emailAddress"]
  server_flag = true
  client_flag = true 
  ou = ["cloud security"]
  organization = ["cloud lab"]
  country = ["uk"]
  locality = ["warrington"]
  # 2 years
  max_ttl = 63113904 
  # 30 days
  ttl = 2592000
  no_store = false
}