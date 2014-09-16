# == Class: fhgfs::meta::service
#
# Private class
#
class fhgfs::meta::service {

  if $fhgfs::meta::manage_service {
    service { 'fhgfs-meta':
      ensure      => $fhgfs::meta::service_ensure,
      enable      => $fhgfs::meta::service_enable,
      name        => $fhgfs::meta::service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $fhgfs::meta::service_subscribe,
    }
  }

}
