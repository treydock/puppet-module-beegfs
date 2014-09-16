# == Class: fhgfs::client
#
# Public class
#
class fhgfs::client (
  $mgmtd_host               = $fhgfs::mgmtd_host,
  $conn_interfaces          = [],
  $conn_interfaces_file     = $fhgfs::conn_interfaces_file['client'],
  $store_directory          = '',
  $mount_path               = '/mnt/fhgfs',
  $build_args               = $fhgfs::client_build_args,
  $build_enabled            = true,
  $rebuild_command          = $fhgfs::client_rebuild_command,
  $release                  = $fhgfs::release,
  $package_version          = $fhgfs::package_version,
  $package_name             = $fhgfs::client_package_name,
  $helperd_package_name     = $fhgfs::helperd_package_name,
  $utils_package_name       = $fhgfs::utils_package_name,
  $manage_service           = true,
  $service_name             = $fhgfs::client_service_name,
  $helperd_service_name     = $fhgfs::helperd_service_name,
  $service_ensure           = 'running',
  $service_enable           = true,
  $service_autorestart      = true,
  $config_overrides         = {},
  $helperd_config_overrides = {},
  $utils_only               = false,
) inherits fhgfs {

  validate_bool($build_enabled)
  validate_bool($manage_service)
  validate_bool($service_autorestart)
  validate_bool($utils_only)

  validate_array($conn_interfaces)

  validate_hash($config_overrides)
  validate_hash($helperd_config_overrides)

  if $service_autorestart {
    $service_subscribe          = [
      File['/etc/fhgfs/fhgfs-client.conf'],
      File['/etc/fhgfs/fhgfs-mounts.conf'],
      File[$conn_interfaces_file],
    ]
    $helperd_service_subscribe  = File['/etc/fhgfs/fhgfs-helperd.conf']
    $autobuild_notify           = Exec['fhgfs-client rebuild']
  } else {
    $service_subscribe          = undef
    $helperd_service_subscribe  = undef
    $autobuild_notify           = undef
  }

  $conn_interfaces_file_value = empty($conn_interfaces) ? {
    true  => '',
    false => $conn_interfaces_file,
  }

  $local_configs = {
    'connInterfacesFile'  => $conn_interfaces_file_value,
    'sysMgmtdHost'        => $mgmtd_host,
  }

  $helperd_default_configs  = $fhgfs::helperd_default_configs[$fhgfs::release]
  $helperd_configs          = merge($helperd_default_configs, $helperd_config_overrides)
  $helperd_config_keys      = $fhgfs::helperd_config_keys[$fhgfs::release]

  $default_configs  = merge($fhgfs::client_default_configs[$fhgfs::release], $local_configs)
  $configs          = merge($default_configs, $config_overrides)
  $config_keys      = $fhgfs::client_config_keys[$fhgfs::release]

  anchor { 'fhgfs::client::start': }->
  class { 'fhgfs::client::install': }->
  class { 'fhgfs::client::config': }->
  class { 'fhgfs::client::service': }->
  anchor { 'fhgfs::client::end': }

}
