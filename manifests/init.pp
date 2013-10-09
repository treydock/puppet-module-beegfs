# == Class: fhgfs
#
# Base class for the FHGFS module.
# This class includes the necessary repo and
# is where the repo parameters are defined.
#
# === Parameters
#
# [*repo_version*]
#
# [*repo_descr*]
#
# [*repo_baseurl*]
#
# [*repo_gpgkey*]
#
# [*repo_gpgcheck*]
#
# [*repo_enabled*]
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
#  class { 'fhgfs': }
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
  $repo_version   = $fhgfs::params::repo_version,
  $repo_descr     = $fhgfs::params::repo_descr,
  $repo_baseurl   = $fhgfs::params::repo_baseurl,
  $repo_gpgkey    = $fhgfs::params::repo_gpgkey,
  $repo_gpgcheck  = '0',
  $repo_enabled   = '1'
) inherits fhgfs::params {

  $package_dependencies  = $fhgfs::params::package_dependencies

  validate_re($repo_gpgcheck, '^(1|0)$')
  validate_re($repo_enabled, '^(1|0)$')

  ensure_packages($package_dependencies)

  case $::osfamily {
    'RedHat': {
      file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs':
        ensure  => present,
        source  => 'puppet:///modules/fhgfs/RPM-GPG-KEY-fhgfs',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
      }

      gpg_key { 'fhgfs':
        path    => '/etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs',
        before  => Yumrepo['fhgfs'],
      }

      yumrepo { 'fhgfs':
        descr     => $repo_descr,
        baseurl   => $repo_baseurl,
        gpgkey    => $repo_gpgkey,
        gpgcheck  => $repo_gpgcheck,
        enabled   => $repo_enabled,
        require   => Package[$package_dependencies],
      }
    }

    default: {}
  }
}
