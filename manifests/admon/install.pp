# private class
class fhgfs::admon::install {

  package { 'fhgfs-admon':
    ensure  => $fhgfs::version,
    name    => $fhgfs::admon_package,
  }

}
