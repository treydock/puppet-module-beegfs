# private class
class fhgfs::storage::install {

  if $fhgfs::storage_service_autorestart {
    $storage_notify = Service['fhgfs-storage']
  } else {
    $storage_notify = undef
  }

  package { 'fhgfs-storage':
    ensure => $fhgfs::version,
    name   => $fhgfs::storage_package,
    notify => $storage_notify,
  }

}
