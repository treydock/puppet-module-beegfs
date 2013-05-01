# == Class: fhgfs
#
# Base class for the FHGFS module.
#
# === Parameters
#
# [*version*]
#
# [*repo_baseurl*]
#
# [*repo_gpgkey*]
#
# [*repo_descr*]
#
# === Variables
#
# [*fhgfs_version*]
#
# [*fhgfs_store_storage_directory*]
#
# [*fhgfs_mgmtd_host*]
#
# === Examples
#
#  class { 'fhgfs':
#    version => '2012.10',
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
class fhgfs (
  $version        = $fhgfs::params::version,
  $repo_baseurl   = 'UNSET',
  $repo_gpgkey    = 'UNSET',
  $repo_descr     = 'UNSET'

) inherits fhgfs::params {

  include fhgfs::repo

  $kernel_source_package  = $fhgfs::params::kernel_source_package

  file { '/etc/fhgfs':
    ensure  => 'directory',
  }

  if ! defined(Package[$kernel_source_package]) {
    package { $kernel_source_package:
      ensure  => 'installed',
      before  => File['/etc/fhgfs'],
    }
  } else {
    Package <| name == $kernel_source_package |> {
      ensure  => 'installed',
      before  => File['/etc/fhgfs'],
    }
  }

}
