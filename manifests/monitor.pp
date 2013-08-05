# == Class: fhgfs::monitor
#
# Adds monitoring capabilities for ZFS
#
# === Parameters
#
# === Examples
#
#  class { 'fhgfs::monitor': }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::monitor inherits fhgfs::params {

  file { '/usr/bin/fhgfs-iostat.rb':
    ensure  => present,
    source  => 'puppet:///modules/fhgfs/fhgfs-iostat.rb',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}
