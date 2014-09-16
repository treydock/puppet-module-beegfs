# == Class: fhgfs::meta::install
#
# Private class
#
class fhgfs::meta::install {

  package { 'fhgfs-meta':
    ensure  => $fhgfs::meta::package_version,
    name    => $fhgfs::meta::package_name,
    require => Yumrepo['fhgfs'],
  }

}
