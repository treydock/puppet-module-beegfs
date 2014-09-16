# == Class: fhgfs::storage::service
#
# Private class
#
class fhgfs::storage::service {

  if $fhgfs::storage::manage_service {
    service { 'fhgfs-storage':
      ensure      => $fhgfs::storage::service_ensure,
      enable      => $fhgfs::storage::service_enable,
      name        => $fhgfs::storage::service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $fhgfs::storage::service_subscribe,
    }
  }

}
