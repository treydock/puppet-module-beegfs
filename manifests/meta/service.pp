# @api private
class beegfs::meta::service {

  if $beegfs::meta_manage_service {
    service { 'beegfs-meta':
      ensure     => $beegfs::meta_service_ensure,
      enable     => $beegfs::meta_service_enable,
      name       => $beegfs::meta_service_name,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => $beegfs::meta_service_subscribe,
    }
  }

}
