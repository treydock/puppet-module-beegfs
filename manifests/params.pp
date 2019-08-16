# @api private
class beegfs::params inherits beegfs::defaults {

  if $facts['has_infiniband'] or $facts['has_mellanox_infiniband'] {
    $client_build_args = '-j8 BEEGFS_OPENTK_IBVERBS=1'
    $with_rdma = true
  } else {
    $client_build_args = '-j8'
    $with_rdma = false
  }

  case $::osfamily {
    'RedHat': {
      $repo_defaults = {
        '7.1' => {
          'descr' => "BeeGFS 7.1.x (RHEL${::operatingsystemmajrelease})",
          'baseurl' => "https://www.beegfs.io/release/beegfs_7_1/dists/rhel${::operatingsystemmajrelease}",
          'customer_baseurl' => "https://LOGIN@www.beegfs.io/login/release/beegfs_7_1/dists/rhel${::operatingsystemmajrelease}",
          'gpgkey' => 'https://www.beegfs.io/release/beegfs_7_1/gpg/RPM-GPG-KEY-beegfs',
        },
      }
      $ib_package                   = 'libbeegfs-ib'
      $client_package               = 'beegfs-client'
      $client_package_dependencies  = ["kernel-devel-${facts['kernelrelease']}"]
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
        'admon'  => '/etc/beegfs/interfaces.admon',
      }
      $conn_net_filter_file = {
        'mgmtd'   => '/etc/beegfs/netfilter.mgmtd',
        'meta'    => '/etc/beegfs/netfilter.meta',
        'storage' => '/etc/beegfs/netfilter.storage',
        'client'  => '/etc/beegfs/netfilter.client',
        'admon'  => '/etc/beegfs/netfilter.admon',
      }
      $conn_tcp_only_filter_file = '/etc/beegfs/tcp-only-filter'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }
}
