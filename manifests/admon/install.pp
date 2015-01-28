# private class
class fhgfs::admon::install {

  if $fhgfs::admon_service_autorestart {
    $admon_notify = Service['fhgfs-admon']
  } else {
    $admon_notify = undef
  }

  package { 'fhgfs-admon':
    ensure => $fhgfs::version,
    name   => $fhgfs::admon_package,
    notify => $admon_notify,
  }

}
