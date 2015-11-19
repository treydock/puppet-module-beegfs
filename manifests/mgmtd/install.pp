# private class
class beegfs::mgmtd::install {

  if $beegfs::mgmtd_service_autorestart {
    $mgmtd_notify = Service['beegfs-mgmtd']
  } else {
    $mgmtd_notify = undef
  }

  package { 'beegfs-mgmtd':
    ensure => $beegfs::version,
    name   => $beegfs::mgmtd_package,
    notify => $mgmtd_notify,
  }

}
