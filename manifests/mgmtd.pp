# == Class: fhgfs::mgmtd
#
# Public class
#
class fhgfs::mgmtd (
  $conn_interfaces      = [],
  $conn_interfaces_file = $fhgfs::params::conn_interfaces_file['mgmtd'],
  $store_directory      = '',
  $package_name         = $fhgfs::params::mgmtd_package_name,
  $manage_service       = true,
  $service_name         = $fhgfs::params::mgmtd_service_name,
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

  $package_version  = $fhgfs::package_version
  $release          = $fhgfs::release

  if $service_autorestart {
    $service_subscribe = empty($conn_interfaces) ? {
      true  => File['/etc/fhgfs/fhgfs-mgmtd.conf'],
      false => [File['/etc/fhgfs/fhgfs-mgmtd.conf'], File[$conn_interfaces_file]],
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
    'storeMgmtdDirectory' => $store_directory,
  }

  $default_configs  = merge($fhgfs::params::mgmtd_default_configs[$release], $local_configs)
  $configs          = merge($default_configs, $config_overrides)
  $config_keys      = $fhgfs::params::mgmtd_config_keys[$release]

  anchor { 'fhgfs::mgmtd::start': }->
  class { 'fhgfs::mgmtd::install': }->
  class { 'fhgfs::mgmtd::config': }->
  class { 'fhgfs::mgmtd::service': }->
  anchor { 'fhgfs::mgmtd::end': }

}
