#!/bin/sh

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

bao secrets enable -path=users kv-v2
bao secrets enable -path=compartilhado kv-v2
bao secrets enable -path=openshift kv-v2
bao secrets enable -path=bancodedados kv-v2
bao secrets enable -path=sistemas kv-v2

