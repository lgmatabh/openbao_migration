#!/bin/sh

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"


cd origin

curl -X "GET"   "$BAO_ADDR_ORIGIN/v1/auth/ad/groups/?list=true" -H "accept: application/json" -H "X-Vault-Token: $BAO_TOKEN_ORIGIN"  | jq -r .data.keys > lista_groups_ad.txt

sed -i 's/\[//g' lista_groups_ad.txt
sed -i 's/\]//g' lista_groups_ad.txt
sed -i 's/\,//g' lista_groups_ad.txt
sed -i 's/\ //g' lista_groups_ad.txt
sed -i 's/\"//g' lista_groups_ad.txt
sed -i '/^$/d' lista_groups_ad.txt

while IFS="" read -r p || [ -n "$p" ]
do

  nome_group=`printf '%s\n' "$p"`

  echo $nome_group > nome_grupo.txt

  # Vault destination

  bao delete identity/group/name/"$(cat nome_grupo.txt)"

  
done < lista_groups_ad.txt
