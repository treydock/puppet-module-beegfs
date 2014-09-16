# == Class: fhgfs::mgmtd::install
#
# Private class
#
class fhgfs::mgmtd::install {

  package { 'fhgfs-mgmtd':
    ensure  => $fhgfs::mgmtd::package_version,
    name    => $fhgfs::mgmtd::package_name,
    require => Yumrepo['fhgfs'],
  }

}
