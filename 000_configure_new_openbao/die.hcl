#Permitir gerenciar segredos de banco de dados 
path "bancodedados/*" {
  capabilities = ["list", "create", "update", "read", "delete"]
}
#Permitir gerenciar segredos do openshift (legado). 
path "openshift/*" {
  capabilities = ["list", "create", "update", "read", "delete"]
}
#Permitir gerenciar segredos dos sistemas. 
path "sistemas/*" {
  capabilities = ["list", "create", "update", "read", "delete"]
}
#Permitir gerenciar os acesso via ssh. 
path "ssh/*" {
  capabilities = ["list", "create", "update", "read", "delete"]
}
#Permitir gerenciar os segredos compartilhados.
path "compartilhado/*" {
  capabilities = ["list", "create", "update", "read", "delete"]
}
