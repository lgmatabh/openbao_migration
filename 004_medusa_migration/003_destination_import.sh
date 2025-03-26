#!/bin/sh
#

set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"
export VAULT_ADDR="$BAO_ADDR_DESTINATION"
export VAULT_TOKEN="$BAO_TOKEN_DESTINATION"

# import from files to destination.

cp /root/.medusa/config_destination.yaml /root/.medusa/config.yaml

./medusa import users users.json --insecure
./medusa import compartilhado compartilhado.json --insecure
./medusa import openshift openshift.json --insecure
./medusa import bancodedados bancodedados.json --insecure
./medusa import sistemas sistemas.json --insecure

