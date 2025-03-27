#!/bin/sh
#
set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

export BAO_ADDR="$BAO_ADDR_ORIGIN"
export BAO_TOKEN="$BAO_TOKEN_ORIGIN"
export VAULT_ADDR="$BAO_ADDR_ORIGIN"
export VAULT_TOKEN="$BAO_TOKEN_ORIGIN"

#export from origin to files.

cp /root/.medusa/config_origin.yaml /root/.medusa/config.yaml

chmod 755 medusa

./medusa export users -f json -o users.json
./medusa export compartilhado -f json -o compartilhado.json
./medusa export openshift -f json -o openshift.json
./medusa export bancodedados -f json -o bancodedados.json
./medusa export sistemas -f json -o sistemas.json

