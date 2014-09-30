# private class
class fhgfs::meta::install {

  package { 'fhgfs-meta':
    ensure => $fhgfs::version,
    name   => $fhgfs::meta_package,
  }

}
