# private class
class beegfs::client::service {

  if $beegfs::utils_only {
    $service_ensure             = 'stopped'
    $service_enable             = false
    $service_subscribe          = undef
    $helperd_service_subscribe  = undef
  } else {
    $service_ensure             = $beegfs::client_service_ensure
    $service_enable             = $beegfs::client_service_enable
    $service_subscribe          = $beegfs::client_service_subscribe
    $helperd_service_subscribe  = $beegfs::helperd_service_subscribe
  }

  if $beegfs::client_manage_service {
    service { 'beegfs-helperd':
      ensure     => $service_ensure,
      enable     => $service_enable,
      name       => $beegfs::helperd_service_name,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => $helperd_service_subscribe,
      before     => Service['beegfs-client'],
    }

    service { 'beegfs-client':
      ensure     => $service_ensure,
      enable     => $service_enable,
      name       => $beegfs::client_service_name,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => $service_subscribe,
    }
  }

}
