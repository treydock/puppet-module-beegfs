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
# [*version*]
#
# [*repo_baseurl*]
#
# [*repo_gpgkey*]
#
# === Examples
#
#  class { 'fhgfs::mgmtd':
#    store_mgmtd_directory  => '/tank/fhgfs/mgmtd',
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
class fhgfs::mgmtd (
  $conn_interfaces                    = false,
  $store_mgmtd_directory              = $fhgfs::params::store_mgmtd_directory,
  $conn_backlog_tcp                   = '64',
  $tune_num_workers                   = '4',
  $tune_client_node_auto_remove_mins  = '0',
  $tune_meta_space_low_limit          = '10G',
  $tune_meta_space_emergency_limit    = '3G',
  $tune_storage_space_low_limit       = '512G',
  $tune_storage_space_emergency_limit = '10G',
  $package_name                       = $fhgfs::params::mgmtd_package_name,
  $package_require                    = $fhgfs::params::package_require,
  $service_name                       = $fhgfs::params::mgmtd_service_name,
  $service_ensure                     = 'running',
  $service_enable                     = true
) inherits fhgfs::params {

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::mgmtd']

  $version = $fhgfs::version

  # This gives the option to not define the service 'ensure' value.
  # Useful if manual intervention is required to allow fhgfs-storage
  # to be started, such as configuring the underlying storage elements.
  validate_re($service_ensure, '(running|stopped|undef)')
  $service_ensure_real  = $service_ensure ? {
    'undef'   => undef,
    default   => $service_ensure,
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

  package { 'fhgfs-mgmtd':
    ensure    => 'present',
    name      => $package_name,
    before    => File['/etc/fhgfs/fhgfs-mgmtd.conf'],
    require   => $package_require,
  }

  service { 'fhgfs-mgmtd':
    ensure      => $service_ensure_real,
    enable      => $service_enable,
    name        => $service_name,
    hasstatus   => true,
    hasrestart  => true,
    subscribe   => File['/etc/fhgfs/fhgfs-mgmtd.conf'],
  }

  file { '/etc/fhgfs/fhgfs-mgmtd.conf':
    ensure  => 'present',
    content => template("fhgfs/${version}/fhgfs-mgmtd.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $store_mgmtd_directory != '' {
    file { $store_mgmtd_directory:
      ensure  => 'directory',
      before  => Service['fhgfs-mgmtd'],
    }
  }

}
