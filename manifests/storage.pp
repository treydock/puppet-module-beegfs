# == Class: fhgfs::storage
#
# Public class
#
class fhgfs::storage (
  $conn_interfaces      = [],
  $conn_interfaces_file = $fhgfs::params::conn_interfaces_file['storage'],
  $store_directory      = '',
  $package_name         = $fhgfs::params::storage_package_name,
  $manage_service       = true,
  $service_name         = $fhgfs::params::storage_service_name,
  $service_ensure       = 'running',
  $service_enable       = true,
  $service_autorestart  = false,
  $config_overrides     = {},
) inherits fhgfs::params {

  include fhgfs

  validate_bool($manage_service)
  validate_bool($service_autorestart)

  validate_array($conn_interfaces)

  validate_hash($config_overrides)

  $mgmtd_host       = $fhgfs::mgmtd_host
  $package_version  = $fhgfs::package_version
  $release          = $fhgfs::release

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

  $default_configs  = merge($fhgfs::params::storage_default_configs[$release], $local_configs)
  $configs          = merge($default_configs, $config_overrides)
  $config_keys      = $fhgfs::params::storage_config_keys[$release]

  anchor { 'fhgfs::storage::start': }->
  class { 'fhgfs::storage::install': }->
  class { 'fhgfs::storage::config': }->
  class { 'fhgfs::storage::service': }->
  anchor { 'fhgfs::storage::end': }

}
