#!/bin/sh

set +x

# Install OpenBAO package

if [ "$(uname)" = "Linux" ] && [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
   
   if [ ! -f /usr/bin/wget ]; then
      apt update
      apt install wget
   fi

   if [ ! -f /usr/bin/bao ]; then
      cd /tmp
      wget https://github.com/openbao/openbao/releases/download/v2.2.0/bao_2.2.0_linux_amd64.deb -O /tmp/bao.deb
      dpkg -i /tmp/bao.deb
      rm -rf /tmp/bao.deb
   fi
   
else
    echo "############################################################"
    echo "##                                                        ##"
    echo "##  Plataform not supported - please perform your adjust  ##"
    echo "##  The program /usr/bin/bao is necessary.                ##"
    echo "##                                                        ##"
    echo "############################################################"

    exit
fi

set -x

# Bao destination - Caution: This vault will be burned!

export BAO_ADDR="https://destination.domain"

#OpenBAO or Vault Destination.

Product="vault" # or Product="openbao"

service $Product stop
service $Product start

bao operator init  -format=json -key-shares=3 -key-threshold=2 > destination_token_and_keys

token=$(cat destination_token_and_keys |jq -r .root_token)
cat 002_setting_token_env.sh|grep -v BAO_TOKEN_DESTINATION > 002_setting_token_env.sh.aux
echo "export BAO_TOKEN_DESTINATION=\"$token\"" >> 002_setting_token_env.sh.aux
mv 002_setting_token_env.sh.aux 002_setting_token_env.sh

service $Product restart

key1=$(cat destination_token_and_keys | jq -r .unseal_keys_b64[0])
key2=$(cat destination_token_and_keys | jq -r .unseal_keys_b64[1])

bao operator unseal $key1
bao operator unseal $key2

bao login $token 
