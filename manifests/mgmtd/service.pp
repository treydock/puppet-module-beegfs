# == Class: fhgfs::mgmtd::service
#
# Private class
#
class fhgfs::mgmtd::service {

  if $fhgfs::mgmtd::manage_service {
    service { 'fhgfs-mgmtd':
      ensure      => $fhgfs::mgmtd::service_ensure,
      enable      => $fhgfs::mgmtd::service_enable,
      name        => $fhgfs::mgmtd::service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $fhgfs::mgmtd::service_subscribe,
    }
  }

}
