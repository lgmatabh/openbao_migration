#Create a specific policy for the migration_user_vault user and associate it with user-> admin_migration.hcl

# root-policy.hcl
path "*" {
    capabilities = [ "read", "create", "list", "patch", "update", "sudo", "delete" ]
}

path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "auth" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List auth methods
path "sys" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List auth methods
path "sys/auth" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
