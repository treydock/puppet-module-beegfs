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
  $store_mgmtd_directory              = $fhgfs::params::store_mgmtd_directory,
  $tune_num_workers                   = '4'
  $tune_meta_node_auto_remove_mins    = '0'
  $tune_storage_node_auto_remove_mins = '0'
  $tune_client_node_auto_remove_mins  = '0'
  $tune_meta_space_low_limit          = '20G'
  $tune_meta_space_emergency_limit    = '5G'
  $tune_storage_space_low_limit       = '2T'
  $tune_storage_space_emergency_limit = '1T'
  $version                            = $fhgfs::version,
  $repo_baseurl                       = $fhgfs::repo_baseurl,
  $repo_gpgkey                        = $fhgfs::repo_gpgkey

) inherits fhgfs {

  include fhgfs::params

  $package_name     = $fhgfs::params::mgmtd_package_name
  $service_name     = $fhgfs::params::mgmtd_service_name
  $package_require  = $fhgfs::params::package_require

  package { 'fhgfs-mgmtd':
    ensure    => 'present',
    name      => $package_name,
    require   => $package_require,
  }

  service { 'fhgfs-mgmtd':
    ensure      => 'running',
    enable      => true,
    name        => $service_name,
    hasstatus   => true,
    hasrestart  => true,
    require     => File['/etc/fhgfs/fhgfs-mgmtd.conf'],
  }

  file { '/etc/fhgfs/fhgfs-mgmtd.conf':
    ensure  => 'present',
    content => template("fhgfs/${version}/fhgfs-mgmtd.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => Package['fhgfs-mgmtd'],
    require => File['/etc/fhgfs'],
    notify  => Service['fhgfs-mgmtd'],
  }

  if $store_mgmtd_directory != '' {
    file { $store_mgmtd_directory:
      ensure  => 'directory',
      before  => Service['fhgfs-mgmtd'],
    }
  }

}
