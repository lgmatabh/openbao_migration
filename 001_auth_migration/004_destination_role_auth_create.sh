#!/bin/sh
set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

export BAO_ADDR="$BAO_ADDR_ORIGIN"
export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

cd destination/roles

bao auth list -detailed |awk '{ print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12 }'| grep -v Path|grep -v "\-\-\-\-"|grep -v auth_token > auth.list.txt

while IFS="" read -r p || [ -n "$p" ]
do
  
  export BAO_ADDR="$BAO_ADDR_ORIGIN"
  export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

  nome_auth=`printf '%s\n' "$p"`
  id=`echo $nome_auth|awk '{ print $1 }'| sed -e s"/\///g"`
 
  echo $id
  
  bao list --format=json auth/$id/role|jq . > $id.json
  total_roles="$(bao list --format=json auth/$id/role|jq length)"
  existe_role="$(cat $id.json)"

 if [ "$existe_role" != "{}" ]; then
     if [ $total_roles -ne 0 ]; then
 
       total_roles=$(( $total_roles - 1 )) 

       for index_role in `seq 0 $total_roles`

       do
          echo $index_role
          export BAO_ADDR="$BAO_ADDR_ORIGIN"
          export BAO_TOKEN="$BAO_TOKEN_ORIGIN"
         
	  bao list --format=json auth/$id/role|jq -r . > $id.roles.json 
          role_name=$(cat $id.roles.json|jq -r .[$index_role])
          
	  bao read --format=json auth/$id/role/$role_name|jq -r .data > $id.$role_name.json
           
          sed -i 's/"alias_name_source"\: "",/"alias_name_source"\: "serviceaccount_uid",/g' $id.$role_name.json
	  sed -i "s/$URL_BAO_ORIGIN/$URL_BAO_DESTINATION/g" $id.$role_name.json

          #grava no destination

          export BAO_ADDR="$BAO_ADDR_DESTINATION"
	  export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

	  cat $id.$role_name.json | bao write auth/$id/role/$role_name - 
          
	  bao read auth/$id/role/$role_name
	  rm $id.roles.json
       done
     fi
  fi
  rm $id.json
done < auth.list.txt

