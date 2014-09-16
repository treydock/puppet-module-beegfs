# == Class: fhgfs::admon::install
#
# Private class
#
class fhgfs::admon::install {

  package { 'fhgfs-admon':
    ensure  => $fhgfs::admon::package_version,
    name    => $fhgfs::admon::package_name,
    require => Yumrepo['fhgfs'],
  }

}
