listener "tcp" {
    address = ":8200"
    tls_disable = 1 
}

api_addr = "http://vault.localhost"

storage "mysql" {
    address = "db:3306"
    username = "vault"
    password = "vault"
    database = "vault"
}

seal "transit" {  
  address = "http://vault-u:8200"
  disable_renewal = "false"
  key_name = "autounseal"
  mount_path = "transit/"
  tls_skip_verify = "true"  
}

cluster_name = "vault-cluster"
ui = true
disable_mlock = true