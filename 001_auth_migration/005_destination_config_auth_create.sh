#!/bin/sh
set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

export BAO_ADDR="$BAO_ADDR_ORIGIN"
export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

cd destination/config

bao auth list -detailed |awk '{ print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12 }'| grep -v Path|grep -v "\-\-\-\-"|grep -v auth_token > auth.list.txt

while IFS="" read -r p || [ -n "$p" ]
do
  
  export BAO_ADDR="$BAO_ADDR_ORIGIN"
  export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

  nome_auth=`printf '%s\n' "$p"`
  id=`echo $nome_auth|awk '{ print $1 }'| sed -e s"/\///g"`
  echo $id
  bao read --format=json auth/$id/config|jq .data > $id.config.json
  existe_config="$(cat $id.config.json)"

  if [ "$existe_config" != "{}" ] && [ ! -z "$existe_config" ]; then

       #Write on destination
       
       sed -i "s/$URL_OCP_ORIGIN/$URL_OCP_DESTINATION/g" $id.config.json 
       sed -i "s/$URL_BAO_ORIGIN/$URL_BAO_DESTINATION/g" $id.config.json 
       sed -i "s/$URL_GITLAB_ORIGIN/$URL_GITLAB_DESTINATION/g" $id.config.json 
       export BAO_ADDR="$BAO_ADDR_DESTINATION"
       export BAO_TOKEN="$BAO_TOKEN_DESTINATION"
       
       if [ "$id" = "openshift" ] || [ "$id" = "openshift-lab" ]; then
	  sed -i 's/\}/,"token_reviewer_jwt":"'"$(cat ../../../000_configure_new_openbao/config_jwt.txt)"'"}/g' openshift.config.json
	  sed -i 's/\"token_reviewer_jwt_set\": false/\"token_reviewer_jwt_set\": true/g' openshift.config.json
       fi 
       cat $id.config.json | bao write auth/$id/config - 
       bao read auth/$id/config
  fi
done < auth.list.txt

