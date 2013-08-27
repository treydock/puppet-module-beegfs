# == Class: fhgfs::monitor::scripts
#
# Scripts intended to be used in monitoring FhGFS
#
# === Parameters
#
# === Examples
#
#  class { 'fhgfs::monitor::scripts': }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::monitor::scripts {

  file { '/usr/bin/fhgfs-iostat.rb':
    ensure  => present,
    source  => 'puppet:///modules/fhgfs/fhgfs-iostat.rb',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/usr/bin/fhgfs-poolstat.rb':
    ensure  => present,
    source  => 'puppet:///modules/fhgfs/fhgfs-poolstat.rb',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}
