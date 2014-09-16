# == Class: fhgfs::admon::service
#
# Private class
#
class fhgfs::admon::service {

  if $fhgfs::admon::manage_service {
    service { 'fhgfs-admon':
      ensure      => $fhgfs::admon::service_ensure,
      enable      => $fhgfs::admon::service_enable,
      name        => $fhgfs::admon::service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $fhgfs::admon::service_subscribe,
    }
  }

}
