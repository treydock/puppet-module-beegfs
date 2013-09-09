# == Class: fhgfs::storage
#
# Manages a FHGFS Storage server
#
# === Parameters
#
# [*store_storage_directory*]
#
# [*mgmtd_host*]
#
# [*version*]
#
# [*repo_baseurl*]
#
# [*repo_gpgkey*]
#
# === Examples
#
#  class { 'fhgfs::storage':
#    store_storage_directory  => '/tank/fhgfs',
#    mgmtd_host               => 'mgmtd01',
#    version                  => '2011.04',
#  }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::storage (
  $conn_interfaces          = false,
  $store_storage_directory  = $fhgfs::params::store_storage_directory,
  $mgmtd_host               = $fhgfs::params::mgmtd_host,
  $package_name             = $fhgfs::params::storage_package_name,
  $package_require          = $fhgfs::params::package_require,
  $service_name             = $fhgfs::params::storage_service_name,
  $service_ensure           = 'running',
  $service_enable           = true,
  $service_autorestart      = true
) inherits fhgfs::params {

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::storage']

  $version = $fhgfs::version

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
    true  => File['/etc/fhgfs/fhgfs-storage.conf'],
    false => undef,
  }

  if $conn_interfaces and !empty($conn_interfaces) {
    if !defined(Class['fhgfs::interfaces']) {
      class { 'fhgfs::interfaces':
        interfaces  => $conn_interfaces,
        service     => $service_name,
      }
    }
    $conn_interfaces_file = $fhgfs::params::interfaces_file
  } else {
    $conn_interfaces_file = ''
  }

  ensure_resource('file', '/etc/fhgfs', {'ensure' => 'directory'})

  package { 'fhgfs-storage':
    ensure    => 'present',
    name      => $package_name,
    before    => File['/etc/fhgfs/fhgfs-storage.conf'],
    require   => $package_require,
  }

  service { 'fhgfs-storage':
    ensure      => $service_ensure_real,
    enable      => $service_enable_real,
    name        => $service_name,
    hasstatus   => true,
    hasrestart  => true,
    subscribe   => $service_subscribe,
  }

  file { '/etc/fhgfs/fhgfs-storage.conf':
    ensure  => 'present',
    content => template("fhgfs/${version}/fhgfs-storage.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $store_storage_directory != '' {
    file { $store_storage_directory:
      ensure  => 'directory',
      before  => Service['fhgfs-storage'],
    }
  }

}
