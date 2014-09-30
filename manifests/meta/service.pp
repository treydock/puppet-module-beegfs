# private class
class fhgfs::meta::service {

  if $fhgfs::meta_manage_service {
    service { 'fhgfs-meta':
      ensure     => $fhgfs::meta_service_ensure,
      enable     => $fhgfs::meta_service_enable,
      name       => $fhgfs::meta_service_name,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => $fhgfs::meta_service_subscribe,
    }
  }

}
