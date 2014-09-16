# == Class: fhgfs::meta
#
# Public class
#
class fhgfs::meta (
  $mgmtd_host           = $fhgfs::mgmtd_host,
  $conn_interfaces      = [],
  $conn_interfaces_file = $fhgfs::conn_interfaces_file['meta'],
  $store_directory      = '',
  $release              = $fhgfs::release,
  $package_version      = $fhgfs::package_version,
  $package_name         = $fhgfs::meta_package_name,
  $manage_service       = true,
  $service_name         = $fhgfs::meta_service_name,
  $service_ensure       = 'running',
  $service_enable       = true,
  $service_autorestart  = false,
  $config_overrides     = {},
) inherits fhgfs {

  validate_bool($manage_service)
  validate_bool($service_autorestart)

  validate_array($conn_interfaces)

  validate_hash($config_overrides)

  if $service_autorestart {
    $service_subscribe = empty($conn_interfaces) ? {
      true  => File['/etc/fhgfs/fhgfs-meta.conf'],
      false => [File['/etc/fhgfs/fhgfs-meta.conf'], File[$conn_interfaces_file]],
    }
  } else {
    $service_subscribe = undef
  }

  $conn_interfaces_file_value = empty($conn_interfaces) ? {
    true  => '',
    false => $conn_interfaces_file,
  }

  $local_configs = {
    'connInterfacesFile'  => $conn_interfaces_file_value,
    'storeMetaDirectory'  => $store_directory,
    'sysMgmtdHost'        => $mgmtd_host,
  }

  $default_configs  = merge($fhgfs::meta_default_configs[$release], $local_configs)
  $configs          = merge($default_configs, $config_overrides)
  $config_keys      = $fhgfs::meta_config_keys[$release]

  anchor { 'fhgfs::meta::start': }->
  class { 'fhgfs::meta::install': }->
  class { 'fhgfs::meta::config': }->
  class { 'fhgfs::meta::service': }->
  anchor { 'fhgfs::meta::end': }

}
