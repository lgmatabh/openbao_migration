#!/bin/sh
set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

cd origin

#Vault origin

export BAO_ADDR="$BAO_ADDR_ORIGIN"
export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

curl -s --header "X-Vault-Token: $BAO_TOKEN_ORIGIN" $BAO_ADDR_ORIGIN/v1/sys/policy|jq -r .policies > policys.txt

sed -i 's/\[//g' policys.txt
sed -i 's/\]//g' policys.txt
sed -i 's/\,//g' policys.txt
sed -i 's/\ //g' policys.txt
sed -i 's/\"//g' policys.txt
sed -i '/^$/d' policys.txt

truncate -s0 todas_policys.sh

echo ". /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh" > todas_policys.sh
echo "export BAO_ADDR='$BAO_ADDR_DESTINATION'" >> todas_policys.sh
echo "export BAO_TOKEN='$BAO_TOKEN_DESTINATION'" >> todas_policys.sh

while IFS="" read -r p || [ -n "$p" ]
do
  nome_policy=`printf '%s\n' "$p"`
  
  if [ $nome_policy != "root" ]; then
     touch  "$p".policy.hcl
     policy=`bao policy read $(echo "$p")`
     printf '%s\n' "$policy" > "$p".policy.hcl 
     comando="bao policy write $p ./$p.policy.hcl" 
     echo $comando >> todas_policys.sh
  fi
  
done < policys.txt

