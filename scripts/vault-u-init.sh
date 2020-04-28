#!/bin/sh
export VAULT_ADDR=http://vault-u:8200
cd /home/vault

vault operator init -key-shares=1 -key-threshold=1 -format=json > secrets/init-u.json
export VAULT_UNSEAL_KEY=`jq -r .unseal_keys_b64[0] secrets/init-u.json`
export VAULT_TOKEN=`jq -r .root_token secrets/init-u.json`

vault operator unseal $VAULT_UNSEAL_KEY

vault secrets enable transit
vault write -f transit/keys/autounseal

vault policy write autounseal ./autounseal.hcl

vault token create -policy=autounseal -format=json > secrets/token.json
echo "VAULT_TOKEN=`jq -r .auth.client_token secrets/token.json`" > vault.env

cp -r /vault/file/* /vault/file-with-seal/