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

  file { 'fhgfs-iostat.rb':
    ensure  => present,
    path    => "${scripts_dir}/fhgfs-iostat.rb",
    source  => 'puppet:///modules/fhgfs/fhgfs-iostat.rb',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { 'fhgfs-poolstat.rb':
    ensure  => present,
    path    => "${scripts_dir}/fhgfs-poolstat.rb",
    source  => 'puppet:///modules/fhgfs/fhgfs-poolstat.rb',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { 'fhgfs-admon-get.rb':
    ensure  => present,
    path    => "${scripts_dir}/fhgfs-admon-get.rb",
    source  => 'puppet:///modules/fhgfs/fhgfs-admon-get.rb',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}
