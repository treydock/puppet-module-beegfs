# == Class: fhgfs::admon
#
# Installs FhGFS Admon
#
# === Parameters
#
# === Examples
#
#  class { 'fhgfs::admon': }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::admon (
  $conn_port_shift      = '0',
  $mgmtd_host           = 'UNSET',
  $package_name         = $fhgfs::params::admon_package_name,
  $package_ensure       = 'UNSET',
  $manage_service       = true,
  $service_name         = $fhgfs::params::admon_service_name,
  $service_ensure       = 'UNSET',
  $service_enable       = 'UNSET',
  $service_autorestart  = false,
  $database_file        = '/var/lib/fhgfs/fhgfs-admon.db'
) inherits fhgfs::params {

  include fhgfs

  validate_bool($manage_service)
  validate_bool($service_autorestart)

  $mgmtd_host_real = $mgmtd_host ? {
    'UNSET' => $fhgfs::mgmtd_host,
    default => $mgmtd_host,
  }

  $package_ensure_real = $package_ensure ? {
    'UNSET' => $fhgfs::package_ensure,
    default => $package_ensure,
  }

  # This gives the option to not manage the service 'ensure' state.
  $service_ensure_real  = $service_ensure ? {
    /UNSET|undef/ => undef,
    default       => $service_ensure,
  }

  # This gives the option to not manage the service 'enable' state.
  $service_enable_real  = $service_enable ? {
    /UNSET|undef/ => undef,
    default       => $service_enable,
  }

  $service_subscribe = $service_autorestart ? {
    true  => File['/etc/fhgfs/fhgfs-admon.conf'],
    false => undef,
  }

  $config_file_before = $manage_service ? {
    true  => Service['fhgfs-admon'],
    false => undef,
  }

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::admon']

  ensure_resource('file', '/etc/fhgfs', {'ensure' => 'directory'})

  package { 'fhgfs-admon':
    ensure  => $package_ensure_real,
    name    => $package_name,
    before  => File['/etc/fhgfs/fhgfs-admon.conf'],
    require => Yumrepo['fhgfs'],
  }

  if $manage_service {
    service { 'fhgfs-admon':
      ensure      => $service_ensure_real,
      enable      => $service_enable_real,
      name        => $service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $service_subscribe,
    }
  }

  file { '/etc/fhgfs/fhgfs-admon.conf':
    ensure  => 'present',
    content => template('fhgfs/fhgfs-admon.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => $config_file_before,
  }

}
