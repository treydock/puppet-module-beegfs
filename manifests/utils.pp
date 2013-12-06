# == Class: fhgfs::utils
#
# Installs the FhGFS utilities
#
# === Parameters
#
# === Examples
#
#  class { 'fhgfs::utils': }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::utils {

  include fhgfs
  include fhgfs::params

  Class['fhgfs::client'] -> Class['fhgfs::utils']

  $package_name     = $fhgfs::params::utils_package_name
  $package_ensure   = $fhgfs::package_ensure

  package { 'fhgfs-utils':
    ensure  => $package_ensure,
    name    => $package_name,
    require => Yumrepo['fhgfs'],
  }

}
