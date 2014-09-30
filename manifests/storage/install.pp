# private class
class fhgfs::storage::install {

  package { 'fhgfs-storage':
    ensure => $fhgfs::version,
    name   => $fhgfs::storage_package,
  }

}
