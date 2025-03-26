#!/bin/sh

set -x
# create a specific policy for the migration in migration_user_vault.


. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

#Origin Vault of migration

export BAO_ADDR="$BAO_ADDR_ORIGIN"
export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

bao policy write admin_migration admin_migration.hcl

bao write -force auth/userpass/users/migration_user_vault token_policies="admin,die,admin_migration"

#Revoke the token for activate policies.

curl -H "X-Vault-Token: $BAO_TOKEN" -X POST "$BAO_ADDR/v1/auth/token/revoke-self"

#log in again

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh
