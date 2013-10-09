# == Class: fhgfs::client::helperd
#
# Manages a FhGFS client's helperd service
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::client::helperd inherits fhgfs::params {

  include fhgfs

  $package_name     = $fhgfs::params::helperd_package_name
  $service_name     = $fhgfs::params::helperd_service_name
  $package_require  = $fhgfs::params::package_require

  ensure_resource('file', '/etc/fhgfs', {'ensure' => 'directory'})

  package { 'fhgfs-helperd':
    ensure    => 'present',
    name      => $package_name,
    before    => File['/etc/fhgfs/fhgfs-helperd.conf'],
    require   => $package_require,
  }

  service { 'fhgfs-helperd':
    ensure      => 'running',
    enable      => true,
    name        => $service_name,
    hasstatus   => true,
    hasrestart  => true,
    subscribe   => File['/etc/fhgfs/fhgfs-helperd.conf'],
    before      => Service['fhgfs-client'],
  }

  file { '/etc/fhgfs/fhgfs-helperd.conf':
    ensure  => 'present',
    content => template('fhgfs/fhgfs-helperd.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
