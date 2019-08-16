# @api private
class beegfs::storage::service {

  if $beegfs::storage_manage_service {
    service { 'beegfs-storage':
      ensure     => $beegfs::storage_service_ensure,
      enable     => $beegfs::storage_service_enable,
      name       => $beegfs::storage_service_name,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => $beegfs::storage_service_subscribe,
    }
  }

}
