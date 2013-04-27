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
  $store_storage_directory  = $fhgfs::params::store_storage_directory,
  $mgmtd_host               = $fhgfs::params::mgmtd_host,
  $version                  = $fhgfs::version,
  $repo_baseurl             = $fhgfs::repo_baseurl,
  $repo_gpgkey              = $fhgfs::repo_gpgkey

) inherits fhgfs {

  include fhgfs::params

  $package_name     = $fhgfs::params::storage_package_name
  $service_name     = $fhgfs::params::storage_service_name
  $package_require  = $fhgfs::params::package_require

  package { 'fhgfs-storage':
    ensure    => 'present',
    name      => $package_name,
    require   => $package_require,
  }

  service { 'fhgfs-storage':
    ensure      => 'running',
    enable      => true,
    name        => $service_name,
    hasstatus   => true,
    hasrestart  => true,
    require     => Package['fhgfs-storage'],
  }

  file { '/etc/fhgfs/fhgfs-storage.conf':
    ensure  => 'present',
    content => template("fhgfs/${version}/fhgfs-storage.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['fhgfs-storage'],
    notify  => Service['fhgfs-storage'],
  }

}
