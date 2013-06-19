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
  $repo_gpgkey              = $fhgfs::repo_gpgkey,
  $service_ensure           = 'running',
  $service_enable           = true
) inherits fhgfs {

  include fhgfs::params
  include fhgfs::repo

  $package_name     = $fhgfs::params::meta_package_name
  $service_name     = $fhgfs::params::meta_service_name
  $package_require  = $fhgfs::params::package_require
  # This gives the option to not define the service 'ensure' value.
  # Useful if manual intervention is required to allow fhgfs-storage
  # to be started, such as configuring the underlying storage elements.
  validate_re($service_ensure, '(running|stopped|undef)')
  $service_ensure_real  = $service_ensure ? {
    'undef'   => undef,
    default   => $service_ensure,
  }

  package { 'fhgfs-meta':
    ensure    => 'present',
    name      => $package_name,
    require   => $package_require,
  }

  service { 'fhgfs-meta':
    ensure      => $service_ensure_real,
    enable      => $service_enable,
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
    before  => Package['fhgfs-meta'],
    require => File['/etc/fhgfs'],
    notify  => Service['fhgfs-meta'],
  }

  if $store_meta_directory != '' {
    file { $store_meta_directory:
      ensure  => 'directory',
      before  => Service['fhgfs-meta'],
    }
  }

}
