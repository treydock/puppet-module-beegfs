# == Class: fhgfs::admon
#
# Public class
#
class fhgfs::admon (
  $database_file_dir    = '/var/lib/fhgfs',
  $package_name         = $fhgfs::params::admon_package_name,
  $manage_service       = true,
  $service_name         = $fhgfs::params::admon_service_name,
  $service_ensure       = 'running',
  $service_enable       = true,
  $service_autorestart  = false,
  $config_overrides     = {},
) inherits fhgfs::params {

  include fhgfs

  validate_bool($manage_service)
  validate_bool($service_autorestart)

  validate_hash($config_overrides)

  $mgmtd_host       = $fhgfs::mgmtd_host
  $package_version  = $fhgfs::package_version
  $release          = $fhgfs::release

  if $service_autorestart {
    $service_subscribe = File['/etc/fhgfs/fhgfs-admon.conf']
  } else {
    $service_subscribe = undef
  }

  $local_configs = {
    'sysMgmtdHost'  => $mgmtd_host,
    'databaseFile'  => "${database_file_dir}/fhgfs-admon.db",
  }

  $default_configs  = merge($fhgfs::params::admon_default_configs[$release], $local_configs)
  $configs          = merge($default_configs, $config_overrides)
  $config_keys      = $fhgfs::params::admon_config_keys[$release]

  anchor { 'fhgfs::admon::start': }->
  class { 'fhgfs::admon::install': }->
  class { 'fhgfs::admon::config': }->
  class { 'fhgfs::admon::service': }->
  anchor { 'fhgfs::admon::end': }

}
