# private class
class fhgfs::storage::service {

  if $fhgfs::storage_manage_service {
    service { 'fhgfs-storage':
      ensure      => $fhgfs::storage_service_ensure,
      enable      => $fhgfs::storage_service_enable,
      name        => $fhgfs::storage_service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $fhgfs::storage_service_subscribe,
    }
  }

}
