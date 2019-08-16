# @api private
class beegfs::mgmtd::service {

  if $beegfs::mgmtd_manage_service {
    service { 'beegfs-mgmtd':
      ensure     => $beegfs::mgmtd_service_ensure,
      enable     => $beegfs::mgmtd_service_enable,
      name       => $beegfs::mgmtd_service_name,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => $beegfs::mgmtd_service_subscribe,
    }
  }

}
