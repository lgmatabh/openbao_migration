#!/bin/sh
set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh


cd destination

rm -rf ../destination/*

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

bao list identity/entity/id|awk '{ print $1 }'| grep -v Keys|grep -v "\-\-\-\-" > identity.list.txt

while IFS="" read -r p || [ -n "$p" ]
do
  id_identity=`printf '%s\n' "$p"`
  echo $id_identity
  bao read -format json identity/entity/id/$id_identity > identity.$id_identity.json
done < identity.list.txt

