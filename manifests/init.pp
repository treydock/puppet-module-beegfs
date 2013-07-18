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
# [*fhgfs_repo_version*]
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
  $repo_baseurl   = $fhgfs::params::repo_baseurl,
  $repo_gpgkey    = $fhgfs::params::repo_gpgkey,
  $repo_descr     = $fhgfs::params::repo_descr
) inherits fhgfs::params {

  $package_dependencies  = [$fhgfs::params::package_dependencies]

  $baseurl  = inline_template("<%= \"${repo_baseurl}\".gsub(/VERSION/, \"${version}\") %>")
  $gpgkey   = inline_template("<%= \"${repo_gpgkey}\".gsub(/VERSION/, \"${version}\") %>")
  $descr    = inline_template("<%= \"${repo_descr}\".gsub(/VERSION/, \"${version}\") %>")

  file { '/etc/fhgfs':
    ensure  => 'directory',
  }

  ensure_packages($package_dependencies)

  case $::osfamily {
    'RedHat': {
      yumrepo { 'fhgfs':
        descr     => $descr,
        baseurl   => $baseurl,
        gpgkey    => $gpgkey,
        gpgcheck  => '0',
        enabled   => '1',
      }
    }

    default: {}
  }

}
