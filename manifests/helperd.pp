# == Class: fhgfs::helperd
#
# Manages a FHGFS helperd server
#
# === Parameters
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
#  class { 'fhgfs::helperd':
#    store_helperd_directory  => '/tank/fhgfs',
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
class fhgfs::helperd (

) inherits fhgfs::params {

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::helperd']

  $version = $fhgfs::version

  $package_name     = $fhgfs::params::helperd_package_name
  $service_name     = $fhgfs::params::helperd_service_name
  $package_require  = $fhgfs::params::package_require

  package { 'fhgfs-helperd':
    ensure    => 'present',
    name      => $package_name,
    require   => $package_require,
  }

  service { 'fhgfs-helperd':
    ensure      => 'running',
    enable      => true,
    name        => $service_name,
    hasstatus   => true,
    hasrestart  => true,
    require     => File['/etc/fhgfs/fhgfs-helperd.conf'],
  }

  file { '/etc/fhgfs/fhgfs-helperd.conf':
    ensure  => 'present',
    content => template("fhgfs/${version}/fhgfs-helperd.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['fhgfs-helperd'],
    notify  => Service['fhgfs-helperd'],
  }

}
