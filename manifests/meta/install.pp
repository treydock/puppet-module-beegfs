# private class
class beegfs::meta::install {

  if $beegfs::meta_service_autorestart {
    $meta_notify = Service['beegfs-meta']
  } else {
    $meta_notify = undef
  }

  package { 'beegfs-meta':
    ensure => $beegfs::version,
    name   => $beegfs::meta_package,
    notify => $meta_notify,
  }

}
