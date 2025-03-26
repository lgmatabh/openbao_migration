#!/bin/sh

set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

cd destination 

#vault origin

export BAO_ADDR="$BAO_ADDR_ORIGIN"
export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

bao auth list -detailed |awk '{ print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12 }'| grep -v Path|grep -v "\-\-\-\-"|grep -v auth_token > auth.list.txt

while IFS="" read -r p || [ -n "$p" ]
do
  nome_auth=`printf '%s\n' "$p"`
  id=`echo $nome_auth|awk '{ print $1 }'| sed -e s"/\///g"`
  echo $id
  
  #Vault origin

  export BAO_ADDR="$BAO_ADDR_ORIGIN"
  export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

  curl -s --header "X-Vault-Token: $BAO_TOKEN_ORIGIN" "$BAO_ADDR_ORIGIN/v1/sys/auth/$id" > auth.$id.json

  #Vault destination
  
  export BAO_ADDR="$BAO_ADDR_DESTINATION"
  export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

  curl --header "X-Vault-Token: $BAO_TOKEN_DESTINATION" --request POST --data @auth.$id.json "$BAO_ADDR_DESTINATION/v1/sys/auth/$id"
done < auth.list.txt

