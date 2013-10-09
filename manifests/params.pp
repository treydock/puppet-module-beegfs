# Class: fhgfs::params
#
#   The fhgfs configuration settings.
#
# === Variables
#
# [*fhgfs_repo_version*]
#
# [*fhgfs_store_storage_directory*]
#
# [*fhgfs_meta_storage_directory*]
#
# [*fhgfs_mgmtd_storage_directory*]
#
# [*fhgfs_mgmtd_host*]
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::params {

  $os_major = inline_template("<%= \"${::operatingsystemrelease}\".split('.')[0] %>")

  $store_storage_directory = $::fhgfs_store_storage_directory ? {
    undef   => '',
    default => $::fhgfs_store_storage_directory,
  }

  $store_meta_directory = $::fhgfs_store_meta_directory ? {
    undef   => '',
    default => $::fhgfs_store_meta_directory,
  }

  $store_mgmtd_directory = $::fhgfs_store_mgmtd_directory ? {
    undef   => '',
    default => $::fhgfs_store_mgmtd_directory,
  }

  $client_with_infiniband = $::has_infiniband ? {
    undef   => false,
    default => $::has_infiniband,
  }

  $mgmtd_host = $::fhgfs_mgmtd_host ? {
    undef   => '',
    default => $::fhgfs_mgmtd_host,
  }

  $meta_with_infiniband = $::has_infiniband ? {
    undef   => false,
    default => $::has_infiniband,
  }

  $monitor_sudo_commands = [
    '/usr/bin/fhgfs-ctl --iostat *',
    '/usr/bin/fhgfs-ctl --listpools *',
  ]

  case $::osfamily {
    'RedHat': {
      $repo_dir                       = "rhel${os_major}"
      $repo_descr                     = "FhGFS 2012.10 (RHEL${os_major})"
      $repo_baseurl                   = "http://www.fhgfs.com/release/fhgfs_2012.10/dists/${repo_dir}"
      $repo_gpgkey                    = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs'
      $package_require                = Yumrepo['fhgfs']
      $package_default_version        =  "2012.10.r8-el${os_major}"
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
      $interfaces_file                = '/etc/fhgfs/interfaces'

      $monitor_tool_defaults  = {
        'zabbix' => {
          'username'  => 'zabbix',
          'conf_dir'  => '/etc/zabbix_agentd.conf.d',
        },
      }

      $monitor_sudoers_path           = '/etc/sudoers.d/fhgfs'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

  $package_version = $::fhgfs_package_version ? {
    undef   => $package_default_version,
    default => $::fhgfs_package_version,
  }

}
