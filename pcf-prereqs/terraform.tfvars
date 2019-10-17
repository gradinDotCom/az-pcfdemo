# limit short_name to <= 8 characters to allow for 4 char hex randomizer
env_short_name         = "azpcf"
location               = "centralus"

##############################
##  CONTRACTS               ##
##  These are items which   ##
##  we are fully dependent  ##
##  upon and represent an   ##
##  agreement set forth     ##
##  with a 'provider'.      ##
##############################

# az account list --query "[?contains(name,'whatever')].{Name:name,SubID:id}" -o tsv
# az account list --query "[?contains(name,'whatever') || contains(name,'something')].[name,id,tenantId]" -o table

# env_name makes up a large part of the resources created by this script, but also
# represents the prefix of our pre-defined resource group (i.e. env_name-rg1).
env_name              = "demo-uscentral-pcf"

# az ad group list --query "[?contains(displayName,'PCF')].displayName" -o tsv
# the owner variable is used as the group name to be given ownership RBAC to the resultant resource group
owner                 = "PAE_PCF"

pcf_spoke_vnet              = "etg-uscentral-etgci-pcf-vnet1"
pcf_spoke_resource_group    = "etg-uscentral-etgci-pcfspoke-rg1"

ops_manager_image_uri       = "https://opsmanagereastus.blob.core.windows.net/images/ops-manager-2.5.19-build.271.vhd"