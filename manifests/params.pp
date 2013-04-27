# Class: fhgfs::params
#
#   The fhgfs configuration settings.
#
# === Variables
#
# [*fhgfs_version*]
#
# [*fhgfs_store_storage_directory*]
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

  $version = $::fhgfs_version ? {
    undef   => '2012.10',
    default => $::fhgfs_version,
  }

  $store_storage_directory  = $::fhgfs_store_storage_directory ? {
    undef   => '',
    default => $::fhgfs_store_storage_directory,
  }
  $store_meta_directory     = $::fhgfs_store_meta_directory ? {
    undef   => '',
    default => $::fhgfs_store_meta_directory,
  }

  $mgmtd_host               = $::fhgfs_mgmtd_host ? {
    undef   => '',
    default => $::fhgfs_mgmtd_host,
  }

  $mgmtd_tune_num_workers             = '4'
  $tune_meta_node_auto_remove_mins    = '0'
  $tune_storage_node_auto_remove_mins = '0'
  $tune_client_node_auto_remove_mins  = '0'
  $tune_meta_space_low_limit          = '20G'
  $tune_meta_space_emergency_limit    = '5G'
  $tune_storage_space_low_limit       = '2T'
  $tune_storage_space_emergency_limit = '1T'

  $os_major = inline_template("<%= \"${::operatingsystemrelease}\".split('.')[0] %>")

  case $::osfamily {
    'RedHat': {
      $repo_dir                       = "rhel${os_major}"
      $repo_descr                     = "FhGFS VERSION (RHEL${os_major})"
      $repo_baseurl                   = "http://www.fhgfs.com/release/fhgfs_VERSION/dists/${repo_dir}"
      $repo_gpgkey                    = 'http://www.fhgfs.com/release/fhgfs_VERSION/gpg/RPM-GPG-KEY-fhgfs'
      $package_require                = Yumrepo['fhgfs']
      $storage_package_name           = 'fhgfs-storage'
      $storage_service_name           = 'fhgfs-storage'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

}
