# private class
class fhgfs::admon::service {

  if $fhgfs::admon_manage_service {
    service { 'fhgfs-admon':
      ensure      => $fhgfs::admon_service_ensure,
      enable      => $fhgfs::admon_service_enable,
      name        => $fhgfs::admon_service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $fhgfs::admon_service_subscribe,
    }
  }

}
