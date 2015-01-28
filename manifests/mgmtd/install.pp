# private class
class fhgfs::mgmtd::install {

  if $fhgfs::mgmtd_service_autorestart {
    $mgmtd_notify = Service['fhgfs-mgmtd']
  } else {
    $mgmtd_notify = undef
  }

  package { 'fhgfs-mgmtd':
    ensure => $fhgfs::version,
    name   => $fhgfs::mgmtd_package,
    notify => $mgmtd_notify,
  }

}
