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
class fhgfs::utils inherits fhgfs::params {

  include fhgfs

  Class['fhgfs'] -> Class['fhgfs::utils']

  $version = $fhgfs::version

  $package_name     = $fhgfs::params::utils_package_name
  $package_require  = $fhgfs::params::package_require

  package { 'fhgfs-utils':
    ensure    => 'present',
    name      => $package_name,
    require   => $package_require,
  }

}
