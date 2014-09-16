# == Class: fhgfs::storage::install
#
# Private class
#
class fhgfs::storage::install {

  package { 'fhgfs-storage':
    ensure  => $fhgfs::storage::package_version,
    name    => $fhgfs::storage::package_name,
    require => Yumrepo['fhgfs'],
  }

}
