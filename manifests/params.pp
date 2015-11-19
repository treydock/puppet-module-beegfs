# private class
class beegfs::params inherits beegfs::defaults {

  $with_infiniband    = str2bool($::has_infiniband)
  $client_build_args  = $with_infiniband ? {
    true    => '-j8 BEEGFS_OPENTK_IBVERBS=1',
    default => '-j8',
  }

  case $::osfamily {
    'RedHat': {
      $repo_defaults = {
        '2015.03' => {
          'descr'   => "BeeGFS 2015.03 (RHEL${::operatingsystemmajrelease})",
          'baseurl' => "http://www.beegfs.com/release/beegfs_2015.03/dists/rhel${::operatingsystemmajrelease}",
          'gpgkey'  => 'http://www.beegfs.com/release/beegfs_2015.03/gpg/RPM-GPG-KEY-beegfs',
        },
      }
      $client_package               = 'beegfs-client'
      $client_package_dependencies  = ['kernel-devel']
      $helperd_package              = 'beegfs-helperd'
      $mgmtd_package                = 'beegfs-mgmtd'
      $meta_package                 = 'beegfs-meta'
      $storage_package              = 'beegfs-storage'
      $admon_package                = 'beegfs-admon'
      $utils_package                = 'beegfs-utils'
      $client_service_name          = 'beegfs-client'
      $helperd_service_name         = 'beegfs-helperd'
      $mgmtd_service_name           = 'beegfs-mgmtd'
      $meta_service_name            = 'beegfs-meta'
      $storage_service_name         = 'beegfs-storage'
      $admon_service_name           = 'beegfs-admon'

      $conn_interfaces_file = {
        'mgmtd'   => '/etc/beegfs/interfaces.mgmtd',
        'meta'    => '/etc/beegfs/interfaces.meta',
        'storage' => '/etc/beegfs/interfaces.storage',
        'client'  => '/etc/beegfs/interfaces.client',
      }
      $conn_net_filter_file = {
        'mgmtd'   => '/etc/beegfs/netfilter.mgmtd',
        'meta'    => '/etc/beegfs/netfilter.meta',
        'storage' => '/etc/beegfs/netfilter.storage',
        'client'  => '/etc/beegfs/netfilter.client',
      }
      $conn_tcp_only_filter_file = '/etc/beegfs/tcp-only-filter'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }
}
