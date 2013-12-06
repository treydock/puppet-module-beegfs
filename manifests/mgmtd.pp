# == Class: fhgfs::mgmtd
#
# Manages a FHGFS Metadata server
#
# === Parameters
#
# [*store_mgmtd_directory*]
#
# [*mgmtd_host*]
#
# === Examples
#
#  class { 'fhgfs::mgmtd':
#    store_mgmtd_directory  => '/tank/fhgfs/mgmtd',
#    mgmtd_host            => 'mgmtd01',
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
class fhgfs::mgmtd (
  $conn_interfaces                    = false,
  $store_mgmtd_directory              = $fhgfs::params::store_mgmtd_directory,
  $conn_backlog_tcp                   = '128',
  $tune_num_workers                   = '4',
  $tune_client_node_auto_remove_mins  = '30',
  $tune_meta_space_low_limit          = '10G',
  $tune_meta_space_emergency_limit    = '3G',
  $tune_storage_space_low_limit       = '512G',
  $tune_storage_space_emergency_limit = '10G',
  $package_name                       = $fhgfs::params::mgmtd_package_name,
  $package_ensure                     = 'UNSET',
  $manage_service                     = true,
  $service_name                       = $fhgfs::params::mgmtd_service_name,
  $service_ensure                     = 'UNSET',
  $service_enable                     = 'UNSET',
  $service_autorestart                = false
) inherits fhgfs::params {

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::mgmtd']

  validate_bool($manage_service)
  validate_bool($service_autorestart)

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
    true  => File['/etc/fhgfs/fhgfs-mgmtd.conf'],
    false => undef,
  }

  $config_file_before = $manage_service ? {
    true  => Service['fhgfs-mgmtd'],
    false => undef,
  }

  if $conn_interfaces and !empty($conn_interfaces) {
    $conn_interfaces_file = "${fhgfs::params::interfaces_file}.mgmtd"
    fhgfs::interfaces { 'mgmtd':
      interfaces  => $conn_interfaces,
      conf_path   => $conn_interfaces_file,
      service     => $service_name,
      restart     => $service_autorestart,
    }
  } else {
    $conn_interfaces_file = ''
  }

  ensure_resource('file', '/etc/fhgfs', {'ensure' => 'directory'})

  package { 'fhgfs-mgmtd':
    ensure  => $package_ensure_real,
    name    => $package_name,
    before  => File['/etc/fhgfs/fhgfs-mgmtd.conf'],
    require => Yumrepo['fhgfs'],
  }

  if $manage_service {
    service { 'fhgfs-mgmtd':
      ensure      => $service_ensure_real,
      enable      => $service_enable_real,
      name        => $service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $service_subscribe,
    }
  }

  file { '/etc/fhgfs/fhgfs-mgmtd.conf':
    ensure  => 'present',
    content => template('fhgfs/fhgfs-mgmtd.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => $config_file_before,
  }

#  if $store_mgmtd_directory != '' {
#    file { $store_mgmtd_directory:
#      ensure  => 'directory',
#      before  => Service['fhgfs-mgmtd'],
#    }
#  }

}
