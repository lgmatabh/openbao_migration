#!/bin/sh

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"
export VAULT_ADDR="$BAO_ADDR_DESTINATION"
export VAULT_TOKEN="$BAO_TOKEN_DESTINATION"

#Adjsut for you Secrets

bao secrets disable users/
bao secrets disable compartilhado/
bao secrets disable openshift/
bao secrets disable bancodedados/
bao secrets disable sistemas/

