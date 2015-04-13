# private class
class fhgfs::params inherits fhgfs::defaults {

  $with_infiniband    = str2bool($::has_infiniband)
  $client_build_args  = $with_infiniband ? {
    true    => '-j8 FHGFS_OPENTK_IBVERBS=1',
    default => '-j8',
  }

  case $::osfamily {
    'RedHat': {
      $repo_defaults = {
        '2012.10' => {
          'descr'   => "FhGFS 2012.10 (RHEL${::operatingsystemmajrelease})",
          'baseurl' => "http://www.fhgfs.com/release/fhgfs_2012.10/dists/rhel${::operatingsystemmajrelease}",
          'gpgkey'  => 'http://www.fhgfs.com/release/fhgfs_2012.10/gpg/RPM-GPG-KEY-fhgfs',
        },
        '2014.01' => {
          'descr'   => "FhGFS 2014.01 (RHEL${::operatingsystemmajrelease})",
          'baseurl' => "http://www.fhgfs.com/release/fhgfs_2014.01/dists/rhel${::operatingsystemmajrelease}",
          'gpgkey'  => 'http://www.fhgfs.com/release/fhgfs_2014.01/gpg/RPM-GPG-KEY-fhgfs',
        }
      }
      $client_package               = 'fhgfs-client'
      $client_package_dependencies  = ['kernel-devel']
      $helperd_package              = 'fhgfs-helperd'
      $mgmtd_package                = 'fhgfs-mgmtd'
      $meta_package                 = 'fhgfs-meta'
      $storage_package              = 'fhgfs-storage'
      $admon_package                = 'fhgfs-admon'
      $utils_package                = 'fhgfs-utils'
      $client_service_name          = 'fhgfs-client'
      $helperd_service_name         = 'fhgfs-helperd'
      $mgmtd_service_name           = 'fhgfs-mgmtd'
      $meta_service_name            = 'fhgfs-meta'
      $storage_service_name         = 'fhgfs-storage'
      $admon_service_name           = 'fhgfs-admon'

      $conn_interfaces_file = {
        'mgmtd'   => '/etc/fhgfs/interfaces.mgmtd',
        'meta'    => '/etc/fhgfs/interfaces.meta',
        'storage' => '/etc/fhgfs/interfaces.storage',
        'client'  => '/etc/fhgfs/interfaces.client',
      }
      $conn_net_filter_file = {
        'mgmtd'   => '/etc/fhgfs/netfilter.mgmtd',
        'meta'    => '/etc/fhgfs/netfilter.meta',
        'storage' => '/etc/fhgfs/netfilter.storage',
        'client'  => '/etc/fhgfs/netfilter.client',
      }
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }
}
