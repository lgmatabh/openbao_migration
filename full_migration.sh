#/bin/sh
# This script executes all the migration and creation steps of Vault/OpenBAO automatically. It executes all the subprograms in the directories in the logical sequence and appropriate for the operation of Vault/OpenBAO.
#
#
# Before executing:
#
# 1) Change the Addr values of Vault/OpenBAO origin and destination in the file: 002_setting_token_env.sh Change the URLs of origin and destination to replace them.

# Read how to install a new Vault or execute an init in an existing one in the file: 000_configure_new_openbao/001_init_vault.sh

exec >All_logfile.log 2>&1

apt install curl -y

chmod -R +x *.sh

date > migration_time.txt

echo "#### step /opt/openbao/openbao_migration/000_configure_new_openbao"

cd /opt/openbao/openbao_migration/000_configure_new_openbao

sh 002_setting_token_env.sh
sh 003_medusa_config.sh
sh 004_origin_policy_add.sh
sh 005_ttl_long_origin_adjust.sh

echo "#### step /opt/openbao/openbao_migration/001_auth_migration"

cd /opt/openbao/openbao_migration/001_auth_migration

sh 001_destination_auth_list.sh
sh 002_origin_auth_list.sh
sh 003_destination_auth_create.sh
sh 004_destination_role_auth_create.sh
sh 005_destination_config_auth_create.sh
sh 006_destination_userpass_users_create.sh

echo "#### step /opt/openbao/openbao_migration/002_policy_migration"

cd /opt/openbao/openbao_migration/002_policy_migration

sh 001_destination_policy_list.sh
sh 002_origin_policy_list.sh
sh 003_destination_policy_auth_adjust.sh
sh 004_destination_policy_create.sh

echo "#### step /opt/openbao/openbao_migration/003_groups_migration"

cd /opt/openbao/openbao_migration/003_groups_migration

sh 001_destination_AD_groups_delete.sh
sh 002_destination_AD_groups_create.sh

echo "#### step /opt/openbao/openbao_migration/004_medusa_migration"

cd /opt/openbao/openbao_migration/004_medusa_migration

sh 001_destination_secrets_enable.sh
sh 002_origin_export.sh
sh 003_destination_import.sh
#sh 004_destination_secrets_disable.sh (optional)

echo "#### step /opt/openbao/openbao_migration/005_policies_identity_migration"

cd /opt/openbao/openbao_migration/005_policies_identity_migration

sh 001_origin_policy_identity_user_create.sh
sh 002_origin_accessor_identity_adjust.sh
sh 003_destination_policies_identity_create.sh
#sh 004_destination_identity_delete.sh (optional)

echo "#### /opt/openbao/openbao_migration/006_origin_with_destination_identity_compare"

cd /opt/openbao/openbao_migration/006_origin_with_destination_identity_compare

sh 001_destination_policies_identity_list.sh
sh 002_origin_policies_identity_list.sh
sh 003_origin_with_destination_compare.sh


echo "##### /opt/openbao/openbao_migration/007_general_settings"

cd /opt/openbao/openbao_migration/007_general_settings

sh 001_destination_ttl_lease_small_adjust.sh
sh 002_destination_sysctl_adjust.sh

# Comment the execution of the cleanup, of these 2 scripts, below, if you wish to analyze the process and integrity of the migration.

sh 003_json_clean.sh
sh 004_directories_clean.sh


cd /opt/openbao/openbao_migration

date >> migration_time.txt

exit