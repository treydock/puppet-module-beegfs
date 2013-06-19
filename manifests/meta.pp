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
  $conn_interfaces          = false,
  $store_meta_directory     = $fhgfs::params::store_meta_directory,
  $mgmtd_host               = $fhgfs::params::mgmtd_host,
  $package_name             = $fhgfs::params::meta_package_name,
  $package_require          = $fhgfs::params::package_require,
  $service_name             = $fhgfs::params::meta_service_name,
  $service_ensure           = 'running',
  $service_enable           = true
) inherits fhgfs::params {

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::meta']

  if $conn_interfaces {
    $conn_interfaces_file = '/etc/fhgfs/interfaces'
    $conn_interfaces_real = is_array($conn_interfaces) ? {
      true  => $conn_interfaces,
      false => split($conn_interfaces, ','),
    }
    validate_array($conn_interfaces_real)
  } else {
    $conn_interfaces_file = ''
    $conn_interfaces_real = []
  }

  $version = $fhgfs::version

  package { 'fhgfs-meta':
    ensure    => 'present',
    name      => $package_name,
    require   => $package_require,
  }

  service { 'fhgfs-meta':
    ensure      => $service_ensure,
    enable      => $service_enable,
    name        => $service_name,
    hasstatus   => true,
    hasrestart  => true,
    require     => File['/etc/fhgfs/fhgfs-meta.conf'],
  }

  file { '/etc/fhgfs/fhgfs-meta.conf':
    ensure  => 'present',
    content => template("fhgfs/${version}/fhgfs-meta.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => Package['fhgfs-meta'],
    require => File['/etc/fhgfs'],
    notify  => Service['fhgfs-meta'],
  }

  if $conn_interfaces_file != '' {
    file { '/etc/fhgfs/interfaces':
      ensure  => 'present',
      path    => $conn_interfaces_file,
      content => template('fhgfs/interfaces.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      before  => Package['fhgfs-meta'],
      require => File['/etc/fhgfs'],
      notify  => Service['fhgfs-meta'],
    }
  }

  if $store_meta_directory != '' {
    file { $store_meta_directory:
      ensure  => 'directory',
      before  => Service['fhgfs-meta'],
    }
  }

}
