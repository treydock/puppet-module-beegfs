# Class: fhgfs::params
#
#   The fhgfs configuration settings.
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

  $os_major = inline_template("<%= \"${::operatingsystemrelease}\".split('.')[0] %>")

  case $::osfamily {
    'RedHat': {
      $repo_class                     = 'fhgfs::repo::el'
      $repo_descr                     = "FhGFS ${version} (RHEL${os_major})"
      $repo_baseurl                   = "http://www.fhgfs.com/release/fhgfs_${version}/dists/rhel${os_major}"
      $repo_gpgkey                    = "http://www.fhgfs.com/release/fhgfs_${version}/gpg/RPM-GPG-KEY-fhgfs"
      $with_optional_packages         = true
      $rdma_service_name              = 'rdma'
      $rdma_service_has_status        = true
      $rdma_service_has_restart       = true
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

}
