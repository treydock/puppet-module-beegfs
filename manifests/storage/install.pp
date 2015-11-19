# private class
class beegfs::storage::install {

  if $beegfs::storage_service_autorestart {
    $storage_notify = Service['beegfs-storage']
  } else {
    $storage_notify = undef
  }

  package { 'beegfs-storage':
    ensure => $beegfs::version,
    name   => $beegfs::storage_package,
    notify => $storage_notify,
  }

}
