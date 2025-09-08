# Vault Configuration File
# This file is used to configure Vault server settings.
# It includes settings for storage, listeners, telemetry, and more.
# For more information, refer to the Vault documentation at https://www.vaultproject.io/docs/configuration

disable_mlock = true
ui            = true
cluster_addr  = "https://10.10.0.2:8201"
api_addr      = "http://10.10.0.2:8200"
cluster_name  = "ocp-vault"

storage "raft" {
  path = "/opt/vault/data"
  node_id = "node1"
}

listener "tcp" {
  address                  = "0.0.0.0:8200"
  tls_disable              = false
  tls_cert_file            = "/etc/vault.d/client.pem"
  tls_key_file             = "/etc/vault.d/cert.key"
  tls_disable_client_certs = true
}