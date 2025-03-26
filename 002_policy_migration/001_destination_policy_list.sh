#!/bin/sh
set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

cd destination 

# Vault destination

export BAO_ADDR="$BAO_ADDR_DESTINATION"
export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

curl -s --header "X-Vault-Token: $BAO_TOKEN_DESTINATION" $BAO_ADDR_DESTINATION/v1/sys/policy|jq -r .keys > policys.txt
sed -i 's/\[//g' policys.txt
sed -i 's/\]//g' policys.txt
sed -i 's/\,//g' policys.txt
sed -i 's/\ //g' policys.txt
sed -i 's/\"//g' policys.txt
sed -i '/^$/d' policys.txt

truncate -s0 todas_policys.sh

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
