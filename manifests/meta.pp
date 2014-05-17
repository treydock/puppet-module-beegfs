# == Class: fhgfs::meta
#
# Manages a FHGFS Metadata server
#
# === Parameters
#
# [*store_meta_directory*]
#
# [*mgmtd_host*]
#
# [*service_ensure*]
#   This gives the option to not define the service 'ensure' value.
#   Useful if manual intervention is required to allow fhgfs-storage
#   to be started, such as configuring the underlying storage elements.
#   Default: running
#
# === Examples
#
#  class { 'fhgfs::meta':
#    store_meta_directory  => '/tank/fhgfs/meta',
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
class fhgfs::meta (
  $conn_interfaces            = false,
  $store_meta_directory       = $fhgfs::params::store_meta_directory,
  $store_use_extended_attribs = true,
  $conn_use_rdma              = true,
  $conn_backlog_tcp           = '128',
  $conn_max_internode_num     = '32',
  $tune_num_workers           = '0',
  $tune_use_per_user_msg_queues = 'false',
  $mgmtd_host                 = 'UNSET',
  $package_name               = $fhgfs::params::meta_package_name,
  $package_ensure             = 'UNSET',
  $manage_service             = true,
  $service_name               = $fhgfs::params::meta_service_name,
  $service_ensure             = 'UNSET',
  $service_enable             = 'UNSET',
  $service_autorestart        = false
) inherits fhgfs::params {

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::meta']

  validate_re("${store_use_extended_attribs}", ['^true$', '^false$'])
  validate_re("${conn_use_rdma}", ['^true$', '^false$'])
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
    true  => File['/etc/fhgfs/fhgfs-meta.conf'],
    false => undef,
  }

  $config_file_before = $manage_service ? {
    true  => Service['fhgfs-meta'],
    false => undef,
  }

  if $conn_interfaces and !empty($conn_interfaces) {
    $conn_interfaces_file = "${fhgfs::params::interfaces_file}.meta"
    fhgfs::interfaces { 'meta':
      interfaces  => $conn_interfaces,
      conf_path   => $conn_interfaces_file,
      service     => $service_name,
      restart     => $service_autorestart,
    }
  } else {
    $conn_interfaces_file = ''
  }

  ensure_resource('file', '/etc/fhgfs', {'ensure' => 'directory'})

  package { 'fhgfs-meta':
    ensure  => $package_ensure_real,
    name    => $package_name,
    before  => File['/etc/fhgfs/fhgfs-meta.conf'],
    require => Yumrepo['fhgfs'],
  }

  if $manage_service {
    service { 'fhgfs-meta':
      ensure      => $service_ensure_real,
      enable      => $service_enable_real,
      name        => $service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $service_subscribe,
    }
  }

  file { '/etc/fhgfs/fhgfs-meta.conf':
    ensure  => 'present',
    content => template('fhgfs/fhgfs-meta.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => $config_file_before,
  }

#  if $store_meta_directory != '' {
#    file { $store_meta_directory:
#      ensure  => 'directory',
#      before  => Service['fhgfs-meta'],
#    }
#  }

}
