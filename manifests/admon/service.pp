# @api private
class beegfs::admon::service {

  if $beegfs::admon_manage_service {
    service { 'beegfs-admon':
      ensure     => $beegfs::admon_service_ensure,
      enable     => $beegfs::admon_service_enable,
      name       => $beegfs::admon_service_name,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => $beegfs::admon_service_subscribe,
    }
  }

}
