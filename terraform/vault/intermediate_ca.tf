########################################################
#    Create a mount point for the Intermediate CA.
########################################################
resource "vault_mount" "pki_intermediate" {
    type = "pki"
    path = "pki-intermediate-ca"
    max_lease_ttl_seconds = 63072000 # 2 years
    description = "Intermediate CA for Cloud Lab"
}

########################################################
# Modify the mount point and set URLs for the issuer and crl.
########################################################
resource "vault_pki_secret_backend_config_urls" "config_urls_int" {
  depends_on = [ vault_mount.pki_intermediate ]  
  backend              = vault_mount.pki_intermediate.path
  issuing_certificates = ["http://192.168.0.25/v1/${vault_mount.pki_intermediate.path}/ca"]
  crl_distribution_points= ["http://192.168.0.25/v1/${vault_mount.pki_intermediate.path}/crl"]
  ocsp_servers = ["http://192.168.0.25/v1/${vault_mount.pki_intermediate.path}/ocsp"]
}

#########################################################
# Step 1
#
# Create a CSR (Certificate Signing Request)
# Behind the scenes this creates a new private key, that has signed the 
# CSR.  Later on, when we store the signed Intermediate Cert, that 
# certificate must match the Private Key generated here.
# I don't see an obvious way to use these APIs to put an intermediate cert 
# into vault that was generated outside of vault.
#########################################################
resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  depends_on = [ vault_mount.pki_intermediate ]

  backend = vault_mount.pki_intermediate.path
  type = "internal"
  # This appears to be overwritten when the CA signs this cert, I'm not sure 
  # the importance of common_name here.
  common_name = "Cloud Lab Intermediate CA"
  format = "pem"
  private_key_format = "der"
  key_type = "rsa"
  key_bits = "4096"
}

#########################################################
# Step 2
#
# Have the Root CA Sign our CSR
#########################################################
resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  depends_on = [ vault_pki_secret_backend_intermediate_cert_request.intermediate, vault_pki_secret_backend_config_ca.ca_config ]
  backend = vault_mount.root.path

  csr = vault_pki_secret_backend_intermediate_cert_request.intermediate.csr
  common_name = "Cloud Lab Intermediate CA"
  exclude_cn_from_sans = true
  ou = "Cloud Security"
  organization = "Cloud Lab"
  locality = "Warrington"
  province = "Cheshire"
  country = "UK"
  ttl = 157680000 #5 years

}
# Save the public part of the certifiate and store it in a local file.  Note that I never extract
# the private key out of vault, so 1) their is no risk of disclosing private key 2) this 
# intermediate cert is bound to vault.
resource "local_sensitive_file" "signed_intermediate" {
    content = vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate
    filename = "${path.root}/output/intermediate_ca/intermediate_ca_cert.pem"
    file_permission = "0400"
}

#########################################################
# Step 3
#
# Now that CSR is processed and we have a signed cert
# Put the Certificate, and The Root CA into the backend 
# mount point.  IF you do not put the CA in here, the 
# chained_ca output of a generated cert will only be 
# the intermedaite cert and not the whole chain.
#########################################################
resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" { 
 backend = vault_mount.pki_intermediate.path

 certificate = "${vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate}\n${tls_self_signed_cert.ca_cert.cert_pem}"
}