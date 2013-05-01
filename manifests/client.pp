# == Class: fhgfs::client
#
# Manages a FHGFS client server
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
#  class { 'fhgfs::client':
#    store_client_directory  => '/tank/fhgfs',
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
class fhgfs::client (
  $mgmtd_host               = $fhgfs::params::mgmtd_host,
  $mount_path               = '/mnt/fhgfs',
  $with_infiniband          = $fhgfs::params::client_with_infiniband,
  $log_helperd_ip           = $fhgfs::params::log_helperd_ip,
  $conn_max_internode_num   = '12',
  $version                  = $fhgfs::version,
  $repo_baseurl             = $fhgfs::repo_baseurl,
  $repo_gpgkey              = $fhgfs::repo_gpgkey

) inherits fhgfs {

  include fhgfs::params

  $package_name     = $fhgfs::params::client_package_name
  $service_name     = $fhgfs::params::client_service_name
  $package_require  = $fhgfs::params::package_require

#  if is_string($mounts) {
#    $mounts_real = split($mounts, ',')
#  } elsif is_array($mounts) {
#    $mounts_real = $mounts
#  } else {
#    fail("Expected an instance of Array or String for mounts, received ${inline_template('<%= ${mounts}.class %>')}")
#  }

  package { 'fhgfs-client':
    ensure    => 'present',
    name      => $package_name,
    require   => $package_require,
  }

  service { 'fhgfs-client':
    ensure      => 'running',
    enable      => true,
    name        => $service_name,
    hasstatus   => true,
    hasrestart  => true,
    require     => File['/etc/fhgfs/fhgfs-client.conf'],
  }

  file { '/etc/fhgfs/fhgfs-client.conf':
    ensure  => 'present',
    content => template("fhgfs/${version}/fhgfs-client.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => Package['fhgfs-client'],
    require => File['/etc/fhgfs'],
    notify  => Service['fhgfs-client'],
  }

  file { '/etc/fhgfs/fhgfs-mounts.conf':
    ensure  => 'present',
    content => template("fhgfs/${version}/fhgfs-mounts.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => Package['fhgfs-client'],
    require => File['/etc/fhgfs'],
    notify  => Service['fhgfs-client'],
  }

  file { '/etc/fhgfs/fhgfs-client-autobuild.conf':
    ensure  => 'present',
    content => template("fhgfs/${version}/fhgfs-client-autobuild.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => Package['fhgfs-client'],
    require => File['/etc/fhgfs'],
    notify  => Service['fhgfs-client'],
  }

}
