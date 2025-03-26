#!/bin/sh

#https://developer.hashicorp.com/vault/api-docs/auth/userpass#list-users

set -x

echo "#### Step:  $0"

. /opt/openbao/openbao_migration/000_configure_new_openbao/002_setting_token_env.sh

cd destination 

#vault origin

export BAO_ADDR="$BAO_ADDR_ORIGIN"
export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

bao list /auth/userpass/users |awk '{ print $1 }'| grep -v Path|grep -v "\-\-\-\-"|grep -v Key >  auth_userpass_users_list.txt

while IFS="" read -r p || [ -n "$p" ]
do
  nome_user=`printf '%s\n' "$p"`
  id=`echo $nome_user|awk '{ print $1 }'| sed -e s"/\///g"`
  echo $id

  #Vault orign

  export BAO_ADDR="$BAO_ADDR_ORIGIN"
  export BAO_TOKEN="$BAO_TOKEN_ORIGIN"

  curl -s --header "X-Vault-Token: $BAO_TOKEN_ORIGIN" "$BAO_ADDR_ORIGIN/v1/auth/userpass/users/$id" > user.$id.json
  
  cat user.$id.json | jq .data.token_policies -r | jq .[] > policies.txt
  sed -i ':a;N;$!ba;s/\n/ /g' policies.txt 
  sed -i 's/\"userpass"}/"userpass","password":"'"$(cat /opt/openbao/openbao_migration/password.txt)"'"}/g' user.$id.json
  sed -i 's/" "/,/g' policies.txt
  sed -i 's/\"//g' policies.txt
 
#Vault destination
  
  export BAO_ADDR="$BAO_ADDR_DESTINATION"
  export BAO_TOKEN="$BAO_TOKEN_DESTINATION"

  curl --header "X-Vault-Token: $BAO_TOKEN_DESTINATION" --request POST --data @user.$id.json "$BAO_ADDR_DESTINATION/v1/auth/userpass/users/$id"
  bao write -force auth/userpass/users/$id token_policies=$(cat policies.txt)

done < auth_userpass_users_list.txt



