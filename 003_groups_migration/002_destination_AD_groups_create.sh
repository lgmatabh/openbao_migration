#!/bin/sh
set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

cd destination 

curl -X "GET"   "$BAO_ADDR_ORIGIN/v1/auth/ad/groups/?list=true" -H "accept: application/json" -H "X-Vault-Token: $BAO_TOKEN_ORIGIN" | jq -r .data.keys > lista_groups_ad.txt

sed -i 's/\[//g' lista_groups_ad.txt
sed -i 's/\]//g' lista_groups_ad.txt
sed -i 's/\,//g' lista_groups_ad.txt
sed -i 's/\ //g' lista_groups_ad.txt
sed -i 's/\"//g' lista_groups_ad.txt
sed -i '/^$/d' lista_groups_ad.txt

truncate -s0 adiciona_groups_ad.sh

bao write auth/ad/config organization=PBH

echo "bao write auth/ad/config organization=PBH" > adiciona_groups_ad.sh

 bao auth list -format=json | jq -r '.["ad/"].accessor' > accessor_ad.txt

while IFS="" read -r p || [ -n "$p" ]
do

  nome_group=`printf '%s\n' "$p"`

  echo $nome_group > nome_grupo.txt
 
  curl -X "GET" "$BAO_ADDR_ORIGIN/v1/auth/ad/groups/$(echo $nome_group)" -H "accept: application/json" -H "X-Vault-Token: $BAO_TOKEN_ORIGIN" | jq -r .data.policies[] > policies_aux.txt 
 
  sed -i 's/ //g' policies_aux.txt

  cat policies_aux.txt
 
  echo $p > name_aux.txt


 export BAO_ADDR="$BAO_ADDR_DESTINATION"
 export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

 bao write -format=json identity/group name="$(cat name_aux.txt)" "policies=$(cat policies_aux.txt)" type="external" metadata=organization="PBH" | jq -r ".data.id" > group_id_$p.txt

  comando="bao write -format=json identity/group name="$(cat name_aux.txt)" "policies=$(cat policies_aux.txt)" type="external" metadata=organization="PBH" | jq -r ".data.id" > group_id_$p.txt"

  echo $comando >> adiciona_groups_ad.sh

  bao write -format=json auth/ad/groups/"$(cat name_aux.txt)" "policies=$(cat policies_aux.txt)" type="external" metadata=organization="PBH" | jq -r .data.id > group_id_auth_ad_$p.txt
  
  comando="bao write -format=json auth/ad/groups/"$(cat name_aux.txt)" "policies=$(cat policies_aux.txt)" type="external" metadata=organization="PBH" | jq -r .data.id > group_id_auth_ad_$p.txt"

  echo $comando >> adiciona_groups_ad.sh

  bao write identity/group-alias name="$(cat name_aux.txt)" mount_accessor=$(cat accessor_ad.txt) canonical_id="$(cat group_id_$p.txt)"

  comando="bao write identity/group-alias name="$(cat name_aux.txt)" mount_accessor=$(cat accessor_ad.txt) canonical_id="$(cat group_id_$p.txt)""
 
  echo $comando >> adiciona_groups_ad.sh

  echo "" >> adiciona_groups_ad.sh


done < lista_groups_ad.txt
