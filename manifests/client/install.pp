# == Class: fhgfs::client::install
#
# Private class
#
class fhgfs::client::install {

  package { 'fhgfs-helperd':
    ensure  => $fhgfs::client::package_version,
    name    => $fhgfs::client::helperd_package_name,
    require => Yumrepo['fhgfs'],
  }

  package { 'fhgfs-client':
    ensure  => $fhgfs::client::package_version,
    name    => $fhgfs::client::package_name,
    require => Yumrepo['fhgfs'],
  }

  package { 'fhgfs-utils':
    ensure  => $fhgfs::client::package_version,
    name    => $fhgfs::client::utils_package_name,
    require => Yumrepo['fhgfs'],
  }

}
