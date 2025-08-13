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
  address       = "10.10.0.2:8200"
  tls_disable   = true
}

