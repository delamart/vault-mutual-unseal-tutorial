#!/bin/sh
export VAULT_ADDR=http://vault:8200
cd /home/vault

vault operator init -recovery-shares=1 -recovery-threshold=1 -format=json > secrets/init.json
export VAULT_TOKEN=`jq -r .root_token secrets/init.json`

vault secrets enable transit
vault write -f transit/keys/autounseal

vault policy write autounseal ./autounseal.hcl

vault token create -policy=autounseal -format=json > secrets/token-u.json
echo "VAULT_TOKEN=`jq -r .auth.client_token secrets/token-u.json`" > vault-u.env