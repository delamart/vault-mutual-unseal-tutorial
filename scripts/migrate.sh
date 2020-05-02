#!/bin/sh
export VAULT_ADDR=http://vault-u:8200
cd /home/vault

export VAULT_UNSEAL_KEY=`jq -r .unseal_keys_b64[0] secrets/init-u.json`
vault operator unseal -migrate $VAULT_UNSEAL_KEY
