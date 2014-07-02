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
# === Examples
#
#  class { 'fhgfs::storage':
#    store_storage_directory  => '/tank/fhgfs',
#    mgmtd_host               => 'mgmtd01',
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
  $conn_port_shift          = '0',
  $tune_num_workers         = '12',
  $tune_use_per_user_msg_queues = 'false',
  $store_storage_directory  = $fhgfs::params::store_storage_directory,
  $mgmtd_host               = 'UNSET',
  $package_name             = $fhgfs::params::storage_package_name,
  $package_ensure           = 'UNSET',
  $manage_service           = true,
  $service_name             = $fhgfs::params::storage_service_name,
  $service_ensure           = 'UNSET',
  $service_enable           = 'UNSET',
  $service_autorestart      = false
) inherits fhgfs::params {

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::storage']

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
    true  => File['/etc/fhgfs/fhgfs-storage.conf'],
    false => undef,
  }

  $config_file_before = $manage_service ? {
    true  => Service['fhgfs-storage'],
    false => undef,
  }

  if $conn_interfaces and !empty($conn_interfaces) {
    $conn_interfaces_file = "${fhgfs::params::interfaces_file}.storage"
    fhgfs::interfaces { 'storage':
      interfaces  => $conn_interfaces,
      conf_path   => $conn_interfaces_file,
      service     => $service_name,
      restart     => $service_autorestart,
    }
  } else {
    $conn_interfaces_file = ''
  }

  ensure_resource('file', '/etc/fhgfs', {'ensure' => 'directory'})

  package { 'fhgfs-storage':
    ensure  => $package_ensure_real,
    name    => $package_name,
    before  => File['/etc/fhgfs/fhgfs-storage.conf'],
    require => Yumrepo['fhgfs'],
  }

  if $manage_service {
    service { 'fhgfs-storage':
      ensure      => $service_ensure_real,
      enable      => $service_enable_real,
      name        => $service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $service_subscribe,
    }
  }

  file { '/etc/fhgfs/fhgfs-storage.conf':
    ensure  => 'present',
    content => template('fhgfs/fhgfs-storage.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => $config_file_before,
  }

#  if $store_storage_directory != '' {
#    file { $store_storage_directory:
#      ensure  => 'directory',
#      before  => Service['fhgfs-storage'],
#    }
#  }

}
