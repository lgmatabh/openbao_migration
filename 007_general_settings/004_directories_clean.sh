#!/bin/sh
set +x

echo "#### Step:  $0"

sudo rm -f  /opt/openbao/openbao_migration/000_configure_new_openbao/origin/*
sudo rm -f  /opt/openbao/openbao_migration/000_configure_new_openbao/destination/*
sudo rm -f  /opt/openbao/openbao_migration/001_auth_migration/origin/*.*
sudo rm -f  /opt/openbao/openbao_migration/001_auth_migration/destination/*.*
sudo rm -f  /opt/openbao/openbao_migration/001_auth_migration/destination/roles/*.*
sudo rm -f  /opt/openbao/openbao_migration/001_auth_migration/destination/config/*.*
sudo rm -f  /opt/openbao/openbao_migration/002_policy_migration/origin/*
sudo rm -f  /opt/openbao/openbao_migration/002_policy_migration/destination/*
sudo rm -f  /opt/openbao/openbao_migration/003_groups_migration/origin/*
sudo rm -f  /opt/openbao/openbao_migration/003_groups_migration/destination/*
sudo rm -f  /opt/openbao/openbao_migration/004_medusa_migration/origin/*
sudo rm -f  /opt/openbao/openbao_migration/004_medusa_migration/destination/*
sudo rm -f  /opt/openbao/openbao_migration/005_policies_identity_migration/origin/*
sudo rm -f  /opt/openbao/openbao_migration/005_policies_identity_migration/destination/*
sudo rm -f  /opt/openbao/openbao_migration/006_origin_with_destination_identity_compare/origin/*
sudo rm -f  /opt/openbao/openbao_migration/006_origin_with_destination_identity_compare/destination/*

