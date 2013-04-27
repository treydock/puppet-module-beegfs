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
# [*repo_baseurl*]
#
# [*repo_gpgkey*]
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
  $store_meta_directory     = $fhgfs::params::store_meta_directory,
  $mgmtd_host               = $fhgfs::params::mgmtd_host,
  $version                  = $fhgfs::version,
  $repo_baseurl             = $fhgfs::repo_baseurl,
  $repo_gpgkey              = $fhgfs::repo_gpgkey

) inherits fhgfs {

  include fhgfs::params

  $package_name     = $fhgfs::params::meta_package_name
  $service_name     = $fhgfs::params::meta_service_name
  $package_require  = $fhgfs::params::package_require

  package { 'fhgfs-meta':
    ensure    => 'present',
    name      => $package_name,
    require   => $package_require,
  }

  service { 'fhgfs-meta':
    ensure      => 'running',
    enable      => true,
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
    require => Package['fhgfs-meta'],
    notify  => Service['fhgfs-meta'],
  }

  if $store_meta_directory != '' {
    file { $store_meta_directory:
      ensure  => 'directory',
      before  => Service['fhgfs-meta'],
    }
  }

}
