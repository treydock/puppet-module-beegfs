# private class
class fhgfs::client::service {

  if $fhgfs::utils_only {
    $service_ensure             = 'stopped'
    $service_enable             = false
    $service_subscribe          = undef
    $helperd_service_subscribe  = undef
  } else {
    $service_ensure             = $fhgfs::client_service_ensure
    $service_enable             = $fhgfs::client_service_enable
    $service_subscribe          = $fhgfs::client_service_subscribe
    $helperd_service_subscribe  = $fhgfs::helperd_service_subscribe
  }

  if $fhgfs::client_manage_service {
    service { 'fhgfs-helperd':
      ensure      => $service_ensure,
      enable      => $service_enable,
      name        => $fhgfs::helperd_service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $helperd_service_subscribe,
      before      => Service['fhgfs-client'],
    }

    service { 'fhgfs-client':
      ensure      => $service_ensure,
      enable      => $service_enable,
      name        => $fhgfs::client_service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $service_subscribe,
    }
  }

}
