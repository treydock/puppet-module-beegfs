# private class
class fhgfs::meta::install {

  if $fhgfs::meta_service_autorestart {
    $meta_notify = Service['fhgfs-meta']
  } else {
    $meta_notify = undef
  }

  package { 'fhgfs-meta':
    ensure => $fhgfs::version,
    name   => $fhgfs::meta_package,
    notify => $meta_notify,
  }

}
