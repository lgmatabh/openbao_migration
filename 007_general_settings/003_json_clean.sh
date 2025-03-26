#!/bin/sh
set +x

echo "#### Step:  $0"

sudo rm -f  /opt/openbao/openbao_migration/001_auth_migration/origin/*.json
sudo rm -f  /opt/openbao/openbao_migration/001_auth_migration/destination/*.json
sudo rm -f  /opt/openbao/openbao_migration/002_policy_migration/origin/*.json
sudo rm -f  /opt/openbao/openbao_migration/002_policy_migration/destination/*.json
sudo rm -f  /opt/openbao/openbao_migration/003_groups_migration/origin/*.json
sudo rm -f  /opt/openbao/openbao_migration/003_groups_migration/destination/*.json
sudo rm -f  /opt/openbao/openbao_migration/004_medusa_migration/*.json
sudo rm -f  /opt/openbao/openbao_migration/005_identity_policies_migration/origin/*.json
sudo rm -f  /opt/openbao/openbao_migration/005_identity_policies_migration/destination/*.json
sudo rm -f  /opt/openbao/openbao_migration/006_compare_identity_destination_with_origin/origin/*.json
sudo rm -f  /opt/openbao/openbao_migration/006_compare_identity_destination_with_origin/destination/*.json

