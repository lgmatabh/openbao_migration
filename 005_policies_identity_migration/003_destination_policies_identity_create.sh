#!/bin/sh
set -x

echo "#### Step:  $0"

# https://developer.hashicorp.com/vault/tutorials/auth-methods/identity#
#

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

cd origin

# Vault origin

export BAO_ADDR="$BAO_ADDR_ORIGIN"
export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

bao list identity/entity/id|awk '{ print $1 }'| grep -v Keys|grep -v "\-\-\-\-" > identity.list.txt

#Vault destination

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

while IFS="" read -r p || [ -n "$p" ]
do
 id_identity=`printf '%s\n' "$p"`

  echo $id_identity
  
   name=$(cat identity.$id_identity.json | jq .data.name -r) 
  policies=$(cat identity.$id_identity.json | jq .data.policies -r)

  total_alias=$(cat identity.$id_identity.json | grep mount_path|wc -l)
  echo $total_alias

  if [ "$total_alias" -eq "0" ]; then
      metadata=$(cat identity.$id_identity.json | jq .data.metadata -r)
  else
    if [ "$total_alias" -eq "1" ]; then
       metadata=$(cat identity.$id_identity.json | jq .data.aliases[0].metadata -r)
    else
        metadata=$(cat identity.$id_identity.json | jq .data.aliases[1].metadata -r)
        if [ ! -n "$metadata" ]; then
	   echo $id_identity >> ../output/identity_multiple_alias_metadata.txt
           cat identity.$id_identity.json > ../output/identity_metadata.$id_identity.json
	fi
    fi
  fi

  echo $name > name.txt
  echo $policies > policies.txt
  echo $metadata > metadata.txt


  tee payload_entity.json <<EOF
  {
    "name": "$(cat name.txt)",
    "metadata": $(cat metadata.txt),
    "policies": $(cat policies.txt)
  }
EOF

# destination

  curl -H "Accept: application/json" -H "X-Vault-Token: $BAO_TOKEN_DESTINATION" -H "X-Vault-Namespace: root" --request POST --data @payload_entity.json $BAO_ADDR_DESTINATION/v1/identity/entity | jq -r ".data.id" > entity_id.txt
  
  cat entity_id.txt

  i=0
  
  while :
   do

     if [ "$total_alias" -ne "0" ] && [ "$i"  -lt "$total_alias" ]; then

	name=$(cat identity.$id_identity.json | jq .data.aliases[$i].name -r)
        mount_accessor=$(cat identity.$id_identity.json | jq .data.aliases[$i].mount_accessor -r)
        metadata=$(cat identity.$id_identity.json | jq .data.aliases[$i].metadata -r)
	custom_metadata=$(cat identity.$id_identity.json | jq .data.aliases[$i].custom_metadata -r)

        if [ ! -z $name ]; then
	   echo $name > name.txt
           echo $mount_accessor > mount_accessor.txt

  tee payload2_"$i"_entity.json <<EOF
  {
    "name": "$(cat name.txt)",
    "canonical_id": "$(cat entity_id.txt)",
    "mount_accessor": "$(cat mount_accessor.txt)"
  }
EOF
          curl -H "X-Vault-Token: $BAO_TOKEN_DESTINATION" --request POST --data @payload2_"$i"_entity.json  $BAO_ADDR_DESTINATION/v1/identity/entity-alias | jq -r ".data"
	
       else
            echo $id_identity >> ../output/alias_sem_nome.txt
            cat identity.$id_identity.json > ../output/alias_sem_nome.$id_identity.json
        fi
     else
	 break 
     fi
  
     i=$((i+1)) 

  done

done < identity.list.txt


