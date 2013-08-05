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
# [*version*]
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
#    version               => '2011.04',
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
  $mgmtd_host                 = $fhgfs::params::mgmtd_host,
  $conn_use_rdma              = $fhgfs::params::meta_with_infiniband,
  $conn_backlog_tcp           = '64',
  $conn_max_internode_num     = '10',
  $tune_num_workers           = '0',
  $package_name               = $fhgfs::params::meta_package_name,
  $package_require            = $fhgfs::params::package_require,
  $service_name               = $fhgfs::params::meta_service_name,
  $service_ensure             = 'running',
  $service_enable             = true
) inherits fhgfs::params {

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::meta']

  $version = $fhgfs::version

  $store_use_extended_attribs_real = $store_use_extended_attribs ? {
    true    => 'true',
    false   => 'false',
    default => $store_use_extended_attribs,
  }
  validate_re($store_use_extended_attribs_real, ['^true$', '^false$'])

  $conn_use_rdma_real = $conn_use_rdma ? {
    true    => 'true',
    false   => 'false',
    default => $conn_use_rdma,
  }
  validate_re($conn_use_rdma_real, ['^true$', '^false$'])

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

  if $conn_interfaces and !empty($conn_interfaces) {
    if !defined(Class['fhgfs::interfaces']) {
      class { 'fhgfs::interfaces':
        interfaces  => $conn_interfaces,
        service     => $service_name,
      }
    }
    $conn_interfaces_file = $fhgfs::params::interfaces_file
  } else {
    $conn_interfaces_file = false
  }

  ensure_resource('file', '/etc/fhgfs', {'ensure' => 'directory'})

  package { 'fhgfs-meta':
    ensure    => 'present',
    name      => $package_name,
    before    => File['/etc/fhgfs/fhgfs-meta.conf'],
    require   => $package_require,
  }

  service { 'fhgfs-meta':
    ensure      => $service_ensure_real,
    enable      => $service_enable_real,
    name        => $service_name,
    hasstatus   => true,
    hasrestart  => true,
    subscribe   => File['/etc/fhgfs/fhgfs-meta.conf'],
  }

  file { '/etc/fhgfs/fhgfs-meta.conf':
    ensure  => 'present',
    content => template("fhgfs/${version}/fhgfs-meta.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $store_meta_directory != '' {
    file { $store_meta_directory:
      ensure  => 'directory',
      before  => Service['fhgfs-meta'],
    }
  }

}
