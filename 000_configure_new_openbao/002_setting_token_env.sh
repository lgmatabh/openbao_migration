#!bin/sh
set -x

export BAO_ADDR_ORIGIN="https://origin.domain"
export BAO_ADDR_DESTINATION="https://destination.domain"

URL=$BAO_ADDR_ORIGIN/v1/auth/userpass/login/migration_user_vault

export BAO_TOKEN_ORIGIN="$(curl -H "Content-Type: application/json" -d "{ \"password\": \"$(cat ../password.txt)\" }" "$URL"| jq -r  .auth.client_token)"


# Optional:

#If migrating from Production to Homologation, change the specific URLs to/from the products below.

#Use the Linux sed command to change the Auth configuration files. If it doesn't match, don't do it.

# Openshift URL's
export URL_OCP_DESTINATION="api.ocp.destination.domain"
export URL_OCP_ORIGIN="api.ocp.origin.domain"

#Vault/OpenBAO URL's

export URL_BAO_DESTINATION="vault.destination.domain"
export URL_BAO_ORIGIN="vault.origin.domain"

#Gitlab/Github URLś

export URL_GITLAB_DESTINATION="gitlab.destination.domain"
export URL_GITLAB_ORIGIN="gitlab.origin.domain"


export BAO_TOKEN_DESTINATION="This token will be updated automatically"
