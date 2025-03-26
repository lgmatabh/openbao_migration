#!/bin/sh
set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

#fixes origin accessors in origin directory for import into destination
#

cd origin 

bao auth list -detailed |awk '{ print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12 }'| grep -v Path|grep -v "\-\-\-\-"|grep -v auth_token > auth.list.txt

while IFS="" read -r p || [ -n "$p" ]
do
  nome_auth=`printf '%s\n' "$p"`
  id=`echo $nome_auth|awk '{ print $1 }'| sed -e s"/\///g"`
  echo $id
  
  export BAO_ADDR="$BAO_ADDR_ORIGIN"
  export BAO_TOKEN="$BAO_TOKEN_ORIGIN"
  mount_accessor_origin=$(bao auth list|grep "$id/"|awk '{print $3}')
  
  export BAO_ADDR="$BAO_ADDR_DESTINATION"
  export BAO_TOKEN="$BAO_TOKEN_DESTINATION"
  mount_accessor_destination=$(bao auth list|grep "$id/"|awk '{print $3}')
  
  sed -i "s/${mount_accessor_origin}/${mount_accessor_destination}/g" *policy.hcl

done < auth.list.txt
