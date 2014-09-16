# Class: fhgfs::params
#
# Private class
#
class fhgfs::params inherits fhgfs::defaults {

  $os_major = $::operatingsystemmajrelease ? {
    undef   => inline_template("<%= \"${::operatingsystemrelease}\".split('.').first %>"),
    default => $::operatingsystemmajrelease,
  }

  $release            = '2012.10'
  $package_version    = 'present'
  $mgmtd_host         = ''
  $with_infiniband    = str2bool($::has_infiniband)
  $client_build_args  = $with_infiniband ? {
    true    => '-j8 FHGFS_OPENTK_IBVERBS=1',
    default => '-j8',
  }

  case $::osfamily {
    'RedHat': {
      $repo_dir                       = "rhel${os_major}"
      $repo_descr                     = "FhGFS ${release} (RHEL${os_major})"
      $repo_baseurl                   = "http://www.fhgfs.com/release/fhgfs_${release}/dists/${repo_dir}"
      $repo_gpgkey                    = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs'
      $mgmtd_package_name             = 'fhgfs-mgmtd'
      $mgmtd_service_name             = 'fhgfs-mgmtd'
      $meta_package_name              = 'fhgfs-meta'
      $meta_service_name              = 'fhgfs-meta'
      $storage_package_name           = 'fhgfs-storage'
      $storage_service_name           = 'fhgfs-storage'
      $client_package_name            = 'fhgfs-client'
      $client_service_name            = 'fhgfs-client'
      $helperd_package_name           = 'fhgfs-helperd'
      $helperd_service_name           = 'fhgfs-helperd'
      $admon_package_name             = 'fhgfs-admon'
      $admon_service_name             = 'fhgfs-admon'
      $utils_package_name             = 'fhgfs-utils'

      $package_dependencies           = ['kernel-devel']
      $conn_interfaces_file           = {
        'mgmtd'   => '/etc/fhgfs/interfaces.mgmtd',
        'meta'    => '/etc/fhgfs/interfaces.meta',
        'storage' => '/etc/fhgfs/interfaces.storage',
        'client'  => '/etc/fhgfs/interfaces.client',
      }
      $client_rebuild_command         = '/etc/init.d/fhgfs-client rebuild'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }
}
