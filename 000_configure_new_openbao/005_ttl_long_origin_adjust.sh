#!/bin/sh
#
set -x
. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

# Vault destination

export BAO_ADDR="$BAO_ADDR_ORIGIN"
export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

#Adjuste for ours auths

bao auth tune -default-lease-ttl=20d token/
bao auth tune -max-lease-ttl=40d token
bao auth tune -default-lease-ttl=10d userpass     
bao auth tune -max-lease-ttl=40d userpass

#Revoke the token for activate tune.

curl -H "X-Vault-Token: $BAO_TOKEN" -X POST "$BAO_ADDR/v1/auth/token/revoke-self"


#log in again

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh
