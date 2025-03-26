#!/bin/sh
#
set -x

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

if  [ ! -d "/root/.medusa" ]; then 
     mkdir /root/.medusa
fi
echo "VAULT_ADDR: "  '"'$BAO_ADDR_DESTINATION'"' > /root/.medusa/config_destination.yaml
echo "VAULT_ADDR: "  '"'$BAO_ADDR_ORIGIN'"' > /root/.medusa/config_origin.yaml
echo "VAULT_TOKEN: " '"'$BAO_TOKEN_DESTINATION'"' >> /root/.medusa/config_destination.yaml
echo "VAULT_TOKEN: " '"'$BAO_TOKEN_ORIGIN'"' >> /root/.medusa/config_origin.yaml
echo "VAULT_SKIP_VERIFY: true" >> /root/.medusa/config_destination.yaml
echo "VAULT_SKIP_VERIFY: true" >> /root/.medusa/config_origin.yaml

