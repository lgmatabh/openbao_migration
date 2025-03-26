#!/bin/sh
set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

cd destination 

#Vault destination

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

vault list identity/entity/id|awk '{ print $1 }'| grep -v Keys|grep -v "\-\-\-\-" > identity.list.txt

while IFS="" read -r p || [ -n "$p" ]
do
  id_identity=`printf '%s\n' "$p"`

  echo $id_identity
  
  bao read -format json identity/entity/id/$id_identity > identity.$id_identity.json

  cat identity.$id_identity.json | jq .data.aliases[].name -r > name.txt
  cat identity.$id_identity.json | jq ".data.policies" -r > policies.txt
  cat identity.$id_identity.json | jq .data.aliases[].mount_accessor -r > mount_accessor.txt
  
  curl --header "X-Vault-Token: $BAO_TOKEN_DESTINATION" --request DELETE $BAO_ADDR_DESTINATION/v1/identity/entity/id/$id_identity

  
done < identity.list.txt

