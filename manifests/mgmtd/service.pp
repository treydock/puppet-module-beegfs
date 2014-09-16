# private class
class fhgfs::mgmtd::service {

  if $fhgfs::mgmtd_manage_service {
    service { 'fhgfs-mgmtd':
      ensure      => $fhgfs::mgmtd_service_ensure,
      enable      => $fhgfs::mgmtd_service_enable,
      name        => $fhgfs::mgmtd_service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $fhgfs::mgmtd_service_subscribe,
    }
  }

}
