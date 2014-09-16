# == Class: fhgfs::storage
#
# Public class
#
class fhgfs::storage (
  $mgmtd_host           = $fhgfs::mgmtd_host,
  $conn_interfaces      = [],
  $conn_interfaces_file = $fhgfs::conn_interfaces_file['storage'],
  $store_directory      = '',
  $release              = $fhgfs::release,
  $package_version      = $fhgfs::package_version,
  $package_name         = $fhgfs::storage_package_name,
  $manage_service       = true,
  $service_name         = $fhgfs::storage_service_name,
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
      true  => File['/etc/fhgfs/fhgfs-storage.conf'],
      false => [File['/etc/fhgfs/fhgfs-storage.conf'], File[$conn_interfaces_file]],
    }
  } else {
    $service_subscribe = undef
  }

  $conn_interfaces_file_value = empty($conn_interfaces) ? {
    true  => '',
    false => $conn_interfaces_file,
  }

  $local_configs = {
    'connInterfacesFile'    => $conn_interfaces_file_value,
    'storeStorageDirectory' => $store_directory,
    'sysMgmtdHost'          => $mgmtd_host,
  }

  $default_configs  = merge($fhgfs::storage_default_configs[$fhgfs::release], $local_configs)
  $configs          = merge($default_configs, $config_overrides)
  $config_keys      = $fhgfs::storage_config_keys[$fhgfs::release]

  anchor { 'fhgfs::storage::start': }->
  class { 'fhgfs::storage::install': }->
  class { 'fhgfs::storage::config': }->
  class { 'fhgfs::storage::service': }->
  anchor { 'fhgfs::storage::end': }

}
