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

  include fhgfs::monitor

  $scripts_dir  = $fhgfs::monitor::scripts_dir

  file { 'fhgfs-pool-status.py':
    ensure  => present,
    path    => "${scripts_dir}/fhgfs-pool-status.py",
    source  => 'puppet:///modules/fhgfs/fhgfs-pool-status.py',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}
