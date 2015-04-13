# private class
class fhgfs::client::install {

  if ! $fhgfs::utils_only {
    if $fhgfs::client_service_autorestart {
      $helperd_notify = Service['fhgfs-helperd']
      $client_notify  = Service['fhgfs-client']
    } else {
      $helperd_notify = undef
      $client_notify  = undef
    }

    if $fhgfs::manage_client_dependencies {
      ensure_packages($fhgfs::client_package_dependencies)
    }
    $_package_require = Package[$fhgfs::client_package_dependencies]

    package { 'fhgfs-helperd':
      ensure => $fhgfs::version,
      name   => $fhgfs::helperd_package,
      notify => $helperd_notify,
    }

    package { 'fhgfs-client':
      ensure  => $fhgfs::version,
      name    => $fhgfs::client_package,
      require => $_package_require,
      notify  => $client_notify,
    }
  }

  package { 'fhgfs-utils':
    ensure => $fhgfs::version,
    name   => $fhgfs::client_utils_package,
  }

}
