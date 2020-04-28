listener "tcp" {
    address = ":8200"
    tls_disable = 1
}

storage "file" {
    path = "/vault/file"
}

api_addr = "http://vaul-u:8200"

cluster_name = "vault-unlock"
ui = true
disable_mlock = true