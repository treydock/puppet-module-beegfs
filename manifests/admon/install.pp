# @api private
class beegfs::admon::install {

  if $beegfs::admon_service_autorestart {
    $admon_notify = Service['beegfs-admon']
  } else {
    $admon_notify = undef
  }

  package { 'beegfs-admon':
    ensure => $beegfs::version,
    name   => $beegfs::admon_package,
    notify => $admon_notify,
  }

}
