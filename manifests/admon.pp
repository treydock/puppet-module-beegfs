# == Class: fhgfs::admon
#
# Public class
#
class fhgfs::admon (
  $mgmtd_host           = $fhgfs::mgmtd_host,
  $database_file_dir    = '/var/lib/fhgfs',
  $release              = $fhgfs::release,
  $package_version      = $fhgfs::package_version,
  $package_name         = $fhgfs::admon_package_name,
  $manage_service       = true,
  $service_name         = $fhgfs::admon_service_name,
  $service_ensure       = 'running',
  $service_enable       = true,
  $service_autorestart  = false,
  $config_overrides     = {},
) inherits fhgfs {

  validate_bool($manage_service)
  validate_bool($service_autorestart)

  validate_hash($config_overrides)

  if $service_autorestart {
    $service_subscribe = File['/etc/fhgfs/fhgfs-admon.conf']
  } else {
    $service_subscribe = undef
  }

  $local_configs = {
    'sysMgmtdHost'  => $mgmtd_host,
    'databaseFile'  => "${database_file_dir}/fhgfs-admon.db",
  }

  $default_configs  = merge($fhgfs::admon_default_configs[$release], $local_configs)
  $configs          = merge($default_configs, $config_overrides)
  $config_keys      = $fhgfs::admon_config_keys[$release]

  anchor { 'fhgfs::admon::start': }->
  class { 'fhgfs::admon::install': }->
  class { 'fhgfs::admon::config': }->
  class { 'fhgfs::admon::service': }->
  anchor { 'fhgfs::admon::end': }

}
