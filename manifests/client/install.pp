# private class
class beegfs::client::install {

  if ! $beegfs::utils_only {
    if $beegfs::client_service_autorestart and $beegfs::client_manage_service {
      $helperd_notify = Service['beegfs-helperd']
      $client_notify  = Service['beegfs-client']
    } else {
      $helperd_notify = undef
      $client_notify  = undef
    }

    if $beegfs::manage_client_dependencies {
      ensure_packages($beegfs::client_package_dependencies)
    }
    $_package_require = Package[$beegfs::client_package_dependencies]

    package { 'beegfs-helperd':
      ensure => $beegfs::version,
      name   => $beegfs::helperd_package,
      notify => $helperd_notify,
    }

    package { 'beegfs-client':
      ensure  => $beegfs::version,
      name    => $beegfs::client_package,
      require => $_package_require,
      notify  => $client_notify,
    }
  }

  package { 'beegfs-utils':
    ensure => $beegfs::version,
    name   => $beegfs::client_utils_package,
  }

}
