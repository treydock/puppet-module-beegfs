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
  $mgmtd_host           = $fhgfs::params::mgmtd_host,
  $package_name         = $fhgfs::params::admon_package_name,
  $package_require      = $fhgfs::params::package_require,
  $service_name         = $fhgfs::params::admon_service_name,
  $service_ensure       = 'running',
  $service_enable       = true,
  $service_autorestart  = true
) inherits fhgfs::params {

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::admon']

  # This gives the option to not define the service 'ensure' value.
  # Useful if manual intervention is required to allow fhgfs-storage
  # to be started, such as configuring the underlying storage elements.
  validate_re($service_ensure, '(running|stopped|undef)')
  $service_ensure_real  = $service_ensure ? {
    'undef'   => undef,
    default   => $service_ensure,
  }

  validate_re("${service_enable}", '(true|false|undef)')
  $service_enable_real  = $service_enable ? {
    'undef'   => undef,
    default   => $service_enable,
  }

  validate_bool($service_autorestart)
  $service_subscribe = $service_autorestart ? {
    true  => File['/etc/fhgfs/fhgfs-admon.conf'],
    false => undef,
  }

  ensure_resource('file', '/etc/fhgfs', {'ensure' => 'directory'})

  package { 'fhgfs-admon':
    ensure    => 'present',
    name      => $package_name,
    before    => File['/etc/fhgfs/fhgfs-admon.conf'],
    require   => $package_require,
  }

  service { 'fhgfs-admon':
    ensure      => $service_ensure_real,
    enable      => $service_enable_real,
    name        => $service_name,
    hasstatus   => true,
    hasrestart  => true,
    subscribe   => $service_subscribe,
  }

  file { '/etc/fhgfs/fhgfs-admon.conf':
    ensure  => 'present',
    content => template('fhgfs/fhgfs-admon.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
