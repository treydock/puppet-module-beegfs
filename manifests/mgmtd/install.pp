# private class
class fhgfs::mgmtd::install {

  package { 'fhgfs-mgmtd':
    ensure  => $fhgfs::version,
    name    => $fhgfs::mgmtd_package,
  }

}
