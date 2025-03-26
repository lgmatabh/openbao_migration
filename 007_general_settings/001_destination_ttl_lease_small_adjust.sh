#!/bin/sh
#

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh


# Vault destination

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

vault auth tune -default-lease-ttl=24h token/

#Adjuste for ours auths

bao auth tune -default-lease-ttl=8h openshift     
bao auth tune -max-lease-ttl=16h openshift     
bao auth tune -default-lease-ttl=4h gitlab     
bao auth tune -max-lease-ttl=8h gitlab     
bao auth tune -default-lease-ttl=4h ldap    
bao auth tune -max-lease-ttl=8h ldap     
bao auth tune -default-lease-ttl=4h ad     
bao auth tune -max-lease-ttl=8h ad     
bao auth tune -default-lease-ttl=5m userpass     
bao auth tune -max-lease-ttl=15m userpass
