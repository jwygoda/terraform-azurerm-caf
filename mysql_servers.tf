
output "mysql_servers" {
  value = module.mysql_servers

}

module "mysql_servers" {
  source     = "./modules/databases/mysql_server"
  depends_on = [module.keyvault_access_policies, module.keyvault_access_policies_azuread_apps]
  for_each   = local.database.mysql_servers

  global_settings     = local.global_settings
  settings            = each.value
  client_config       = local.client_config
  resource_group_name = local.resource_groups[each.value.resource_group_key].name
  location            = lookup(each.value, "region", null) == null ? local.resource_groups[each.value.resource_group_key].location : local.global_settings.regions[each.value.region]
  keyvault_id = coalesce(
    try(each.value.administrator_login_password, null),
    try(module.keyvaults[each.value.keyvault_key].id, null),
    try(local.combined_objects_keyvaults[each.value.keyvault.lz_key][each.value.keyvault.key].id, null),
    try(local.combined_objects_keyvaults[local.client_config.landingzone_key][each.value.keyvault.key].id, null)
  )
  storage_accounts  = module.storage_accounts
  azuread_groups    = []
  vnets             = local.combined_objects_networking
  subnet_id         = try(each.value.vnet_key, null) == null ? null : try(local.combined_objects_networking[local.client_config.landingzone_key][each.value.vnet_key].subnets[each.value.subnet_key].id, local.combined_objects_networking[each.value.lz_key][each.value.vnet_key].subnets[each.value.subnet_key].id)
  private_endpoints = try(each.value.private_endpoints, {})
  resource_groups   = try(each.value.private_endpoints, {}) == {} ? null : local.resource_groups
  base_tags         = try(local.global_settings.inherit_tags, false) ? local.resource_groups[each.value.resource_group_key].tags : {}
  private_dns       = local.combined_objects_private_dns
  diagnostics       = local.combined_diagnostics
}
